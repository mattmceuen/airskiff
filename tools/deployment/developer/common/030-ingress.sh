#!/bin/bash

# Copyright 2017 The Openstack-Helm Authors.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

set -xe

CURRENT_DIR="$(pwd)"
: ${OSH_INFRA_PATH:="../openstack-helm-infra"}
cd ${OSH_INFRA_PATH}

#NOTE: Lint and package chart
make ingress

#NOTE: Deploy command
: ${AS_EXTRA_HELM_ARGS:=""}
tee /tmp/ingress-kube-system.yaml << EOF
deployment:
  mode: cluster
  type: DaemonSet
network:
  host_namespace: true
EOF
helm upgrade --install ingress-kube-system ./ingress \
  --namespace=kube-system \
  --values=/tmp/ingress-kube-system.yaml \
  ${AS_EXTRA_HELM_ARGS} \
  ${AS_EXTRA_HELM_ARGS_INGRESS_KUBE_SYSTEM}

#NOTE: Wait for deploy
./tools/deployment/common/wait-for-pods.sh kube-system

#NOTE: Display info
helm status ingress-kube-system

#NOTE: Deploy namespace ingress
for NAMESPACE in ucp ceph; do
  helm upgrade --install ingress-${NAMESPACE} ./ingress \
    --namespace=${NAMESPACE} \
    ${AS_EXTRA_HELM_ARGS} \
    ${AS_EXTRA_HELM_ARGS_INGRESS_OPENSTACK}

  #NOTE: Wait for deploy
  ./tools/deployment/common/wait-for-pods.sh ${NAMESPACE}

  #NOTE: Display info
  helm status ingress-${NAMESPACE}
done

cd ${CURRENT_DIR}

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
: ${OSH_PATH:="../openstack-helm"}
cd ${OSH_PATH}

#NOTE: Lint and package chart
make postgresql

#NOTE: Deploy command
: ${AS_EXTRA_HELM_ARGS:=""}
helm upgrade --install postgresql ./postgresql \
    --namespace=ucp \
    --set pod.replicas.server=1 \
    ${AS_EXTRA_HELM_ARGS} \
    ${AS_EXTRA_HELM_ARGS_MARIADB}

#NOTE: Wait for deploy
./tools/deployment/common/wait-for-pods.sh ucp

#NOTE: Validate Deployment info
helm status postgresql

cd ${CURRENT_DIR}

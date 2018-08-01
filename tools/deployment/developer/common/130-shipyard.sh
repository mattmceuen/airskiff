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
: ${SY_PATH:="../airship-shipyard"}
cd ${SY_PATH}

#NOTE: Lint and package chart
# To create a fresh local docker image: quay.io/airshipit/shipyard:untagged
# make

make charts

#NOTE: Deploy command
: ${AS_EXTRA_HELM_ARGS:=""}
tee /tmp/shipyard.yaml << EOF
images:
  tags:
    shipyard:         'quay.io/airshipit/shipyard:untagged'
    shipyard_db_sync: 'quay.io/airshipit/shipyard:untagged'
    airflow:          'quay.io/airshipit/airflow:untagged'
    airflow_db_sync:  'quay.io/airshipit/airflow:untagged'
pod:
  replicas:
    shipyard:
      api: 1
    airflow:
      web: 1
      worker: 1
      flower: 1
      scheduler: 1
conf:
  shipyard:
    # Trick SY into sub-validating with Armada rather than DD / Promenade,
    # since we have Armada deployed but not the others.
    drydock:
      service_type: 'armada'
    promenade:
      service_type: 'armada'
EOF

helm upgrade --install shipyard ./charts/shipyard \
    --namespace=ucp \
    --values=/tmp/shipyard.yaml \
    ${AS_EXTRA_HELM_ARGS} \
    ${AS_EXTRA_HELM_ARGS_MARIADB}

#NOTE: Wait for deploy
${CURRENT_DIR}/tools/deployment/common/wait-for-pods.sh ucp

#NOTE: Validate Deployment info
helm status shipyard

cd ${CURRENT_DIR}

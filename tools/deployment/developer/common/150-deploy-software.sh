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
: ${PL_PATH:="../airship-pegleg"}
: ${SY_PATH:="../airship-shipyard"}
#cd ${PL_PATH}

# The image that pegleg.sh will use. This matches what is built by pegleg `make`
: ${PL_IMAGE:=quay.io/airshipit/pegleg:latest}

# Validate deployment manifests
: ${PEGLEG:="${PL_PATH}/tools/pegleg.sh"}
: ${PL_SITE:="osh"}
: ${PL_OUTPUT:="peggles"}
cd ${CURRENT_DIR}

# Lint deployment manifests
IMAGE=${PL_IMAGE} ${PEGLEG} site -r deployment_files/ lint ${PL_SITE}

# Collect the deployment manifests that will be used
mkdir -p ${PL_OUTPUT}
IMAGE=${PL_IMAGE} ${PEGLEG} site -r deployment_files/ collect ${PL_SITE} -s ${PL_OUTPUT}
cp -rp ${CURRENT_DIR}/${PL_OUTPUT} ${SY_PATH}/${SY_OUTPUT}

# Deploy the site
. tools/deployment/common/os-env.sh
cd ${SY_PATH}
: ${SHIPYARD:="./tools/shipyard.sh"}
: ${SY_AUTH:="--os-project-domain-name=$OS_PROJECT_DOMAIN_NAME \
              --os-user-domain-name=$OS_USER_DOMAIN_NAME \
              --os-project-name=$OS_PROJECT_NAME \
              --os-username=$OS_USERNAME \
              --os-password=$OS_PASSWORD \
              --os-auth-url=$OS_AUTH_URL "}

${SHIPYARD} ${SY_AUTH} create configdocs the-design \
             --replace \
             --directory=/target/${PL_OUTPUT}

${SHIPYARD} ${SY_AUTH} commit configdocs --force
${SHIPYARD} ${SY_AUTH} create action update_software --allow-intermediate-commits

# To see the status of the action:
#     shipyard describe action 01CKPKZ2FXSMYV0V99GH3R3W3P
# To see the status of an action's steps:
#     shipyard logs step/01CKPKZ2FXSMYV0V99GH3R3W3P/deployment_configuration
# To see the logs from a step:
#     shipyard get configdocs # see what buckets you have

cd ${CURRENT_DIR}

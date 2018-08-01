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
: ${DH_PATH:="../airship-deckhand"}
cd ${DH_PATH}

#NOTE: Lint and package chart
# To create a fresh local docker image: quay.io/attcomdev/deckhand:latest
# make

make charts

#NOTE: Deploy command
: ${AS_EXTRA_HELM_ARGS:=""}
helm upgrade --install deckhand ./charts/deckhand \
    --namespace=ucp \
    ${AS_EXTRA_HELM_ARGS} \
    ${AS_EXTRA_HELM_ARGS_MARIADB}

#NOTE: Wait for deploy
${CURRENT_DIR}/tools/deployment/common/wait-for-pods.sh ucp

#NOTE: Validate Deployment info
helm status deckhand

cd ${CURRENT_DIR}

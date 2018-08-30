#!/bin/bash
set -xe

sed -i -e "/type:/ a\        proxy_server: ${PROXY}" \
  deployment_files/global/v1.0demo/software/config/versions.yaml

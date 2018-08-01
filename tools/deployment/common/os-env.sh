#!/bin/bash
export OS_PROJECT_DOMAIN_NAME=`grep project_domain_name /etc/openstack/clouds.yaml | cut -d "'" -f 2`
export OS_USER_DOMAIN_NAME=`grep user_domain_name /etc/openstack/clouds.yaml | cut -d "'" -f 2`
export OS_PROJECT_NAME=`grep project_name /etc/openstack/clouds.yaml | cut -d "'" -f 2`
export OS_USERNAME=`grep username /etc/openstack/clouds.yaml | cut -d "'" -f 2`
export OS_PASSWORD=`grep password /etc/openstack/clouds.yaml | cut -d "'" -f 2`
export OS_AUTH_URL=`grep auth_url /etc/openstack/clouds.yaml | cut -d "'" -f 2`

========
Airskiff
========

Skiff (n): a shallow, flat-bottomed open boat

Airskiff (n): A learning and dev environment for Airship

Warning: Work in progress!!

Purpose
-------

Airskiff is an easy way to get started with the software delivery components
of Airship:

* Pegleg
* Shipyard
* Deckhand
* Armada

The scripts in this project are modeled after the All-in-One KubeADM and gate
scripts from the OpenStack-Helm project, so if you're familiar with those you're
halfway there.  The shell scripts can be used to:

* Download, build, and containerize the Airship projects above from source
* Stand up a Kubernetes cluster via KubeADM
* Deploy Shipyard, Deckhand, and Armada via the Helm CLI
* Deploy OpenStack using Airship, declarative YAMLs, and OpenStack-Helm charts

There is a set of scripts for ceph- and nfs-backed cluster storage.  To deploy
the ceph scripts for example, please run these commands in sequence:

::

  cd airskiff
  ./tools/deployment/developer/ceph/000-install-packages.sh
  ./tools/deployment/developer/ceph/005-make-airship.sh
  ./tools/deployment/developer/ceph/010-deploy-k8s.sh
  ./tools/deployment/developer/ceph/020-setup-client.sh
  ./tools/deployment/developer/ceph/030-ingress.sh
  ./tools/deployment/developer/ceph/040-ceph.sh
  ./tools/deployment/developer/ceph/045-ceph-ns-activate.sh
  ./tools/deployment/developer/ceph/050-mariadb.sh
  ./tools/deployment/developer/ceph/060-rabbitmq.sh
  ./tools/deployment/developer/ceph/070-memcached.sh
  ./tools/deployment/developer/ceph/080-keystone.sh
  ./tools/deployment/developer/ceph/090-postgresql.sh
  ./tools/deployment/developer/ceph/100-barbican.sh
  ./tools/deployment/developer/ceph/110-deckhand.sh
  ./tools/deployment/developer/ceph/120-armada.sh
  ./tools/deployment/developer/ceph/130-shipyard.sh
  ./tools/deployment/developer/ceph/140-pegleg.sh
  ./tools/deployment/developer/ceph/150-deploy-software.sh

Don't forget to read the contents of these scripts as you run them --
learning what's going on is the point!

Once you have a running cluster on your laptop, if you're
doing development on one of these projects (e.g. Shipyard), you can
deploy your changes into a running cluster like so:

::

  cd airship-shipyard
  make
  cd ../airskiff
  ./tools/deployment/developer/common/130-shipyard.sh


Next Steps
----------

After familiarizing yourself with these Airship software delivery projects, you
can move on to the infrastructure provisioning projects Promenade and Drydock.
To demonstrate the full stack of Airship components, please try out the 
`Airship-in-a-Bottle <https://github.com/openstack/airship-in-a-bottle>`_
project.

Please bring any questions you have around Airship to the #airshipit IRC
channel on `Freenode <https://webchat.freenode.net>`_.  We would love to welcome
new developers, testers, documenters, and operators!

Thanks
------

This project is based on work from the OpenStack-Helm and Airship-in-a-Bottle
projects.


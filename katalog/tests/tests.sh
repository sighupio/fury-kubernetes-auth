#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.


# ---------------------------------------------------
#                    THIS IS WIP
# ---------------------------------------------------
# Right now we only check that the components are correctly deployed and come up.
# Here's some to do:
# - [ ] check that Dex talks to the LDAP server.
# - [ ] check that Gangplank redirects to Dex, login works and the you get the kubeconfig.
# - [ ] deploy Grafana or some other ingess, add the route to Pomerium and check that SSO is working.
#
# Note:
#  There are some placeholders like <service name>.127.0.0.1.nip.io that need to be replaced when working on the more advanced tests.

set -e

bash katalog/tests/install-kapp.sh

echo "> Deploying pre-requistes"
kapp deploy --app prerequisites --file https://raw.githubusercontent.com/sighupio/fury-kubernetes-monitoring/refs/tags/v3.3.0-rc.1/katalog/prometheus-operator/crds/0servicemonitorCustomResourceDefinition.yaml --yes

echo "> Deploying LDAP server"
kapp deploy --app ldap --file <(kustomize build katalog/tests/ldap-server) --yes

echo "> Deploying Dex"
kapp deploy --app dex --file <(kustomize build katalog/tests/dex) --yes

echo "> Deploying Gangplank"
kapp deploy --app gangplank --file <(kustomize build katalog/tests/gangplank) --yes

echo "> Deploying Pomerium"
kapp deploy --app pomerium --file <(kustomize build katalog/tests/pomerium) --yes

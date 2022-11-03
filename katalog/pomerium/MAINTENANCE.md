# Pomerium Package Maintenance Guide

Upstream documentation is located at: <https://www.pomerium.com/docs/>
Upgrade docs are here: <https://www.pomerium.com/docs/overview/upgrading>

> ⚠️ Notice that the component that we deploy is "Pomerium" all-in-one and not the Pomerium Ingress Controller. We use Pomerium only in Forward mode to auth the Ingress requests.

Releases of Pomerium can be found at: <https://github.com/pomerium/pomerium>

Here are some examples for Kubernetes deployments: <https://github.com/pomerium/pomerium/tree/main/examples/kubernetes>

## Update

To update the Pomerium package, follow the next steps:

1. The manifests for Pomerium are custom, there is no upstream to follow. Read carefully the release notes from upstream and adjust the manifests.
2. Update the documentation.
3. Sync the new image tag to Fury's registry.

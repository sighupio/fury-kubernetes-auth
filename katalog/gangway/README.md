# Gangway

<!-- <KFD-DOCS> -->

Gangway is an application that can be used to enable authentication flows via OIDC for a Kubernetes cluster.

## Requirements

- Kubernetes >= `1.20.0`
- Kustomize >= `v3`

## Image repository and tag

- Dex repository: <https://github.com/vmware-archive/gangway>
- Dex container image: `gcr.io/heptio-images/gangway:v3.2.0`

## Configuration

FIXME: ADD MISSING DOCS

## Deployment

You can deploy Dex by running the following command in the folder of this package:

```shell
kustomize build | kubectl apply -f -
```

## License

For license details please see [LICENSE](https://sighup.io/fury/license)

<!-- </KFD-DOCS> -->

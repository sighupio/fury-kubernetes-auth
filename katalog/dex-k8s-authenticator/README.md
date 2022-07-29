# Dex Kubernetes Authenticator

<!-- <KFD-DOCS> -->

A helper web-app talks to one or more Dex Identity services to generate kubectl commands for creating and modifying a kubeconfig.

## Requirements

- Kubernetes >= `1.20.0`
- Kustomize >= `v3`

## Image repository and tag

- Dex K8s Authenticator repository: <https://github.com/mintel/dex-k8s-authenticator/>
- Dex container image: `mintel/dex-k8s-authenticator:1.1.0`

## Configuration

FIXME: COMPLETE DOCS

## Deployment

You can deploy Dex K8s Authenticator by running the following command in the folder of this package:

```shell
kustomize build | kubectl apply -f -
```

<!-- </KFD-DOCS> -->

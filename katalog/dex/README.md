# Dex

<!-- <KFD-DOCS> -->

Dex is an OpenID Connect (OIDC) identity and OAuth 2.0 provider.

This package deploys Dex to authenticate users via LDAP.

## Requirements

- Kubernetes >= `1.20.0`
- Kustomize >= `v3`

## Image repository and tag

- Dex repository: <https://github.com/dexidp/dex>
- Dex container image: `quay.io/dexidp/dex:v2.20.0`

## Configuration

Dex is deployed with the following default configuration:

- Replica number: `1`
- Listens on port `5556`
- Resource limits are `250m` for CPU and `200Mi` for memory

To configure Dex create a YAML file named `config.yml` with the following content:

<!-- FIXME:NEEDS INSTRUCTIONS -->
https://dexidp.io/docs/


## Deployment

You can deploy Dex by running the following command in the folder of this package:

```shell
kustomize build | kubectl apply -f -
```

<!-- </KFD-DOCS> -->

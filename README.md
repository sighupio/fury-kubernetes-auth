<!-- markdownlint-disable MD033 -->
<h1>
    <img src="https://github.com/sighupio/fury-distribution/blob/master/docs/assets/fury-epta-white.png?raw=true" align="left" width="90" style="margin-right: 15px"/>
    Kubernetes Fury Auth
</h1>
<!-- markdownlint-enable MD033 -->

![Release](https://img.shields.io/github/v/release/sighupio/fury-kubernetes-auth?label=Latest%20Release)
![License](https://img.shields.io/github/license/sighupio/fury-kubernetes-auth?label=License)
![Slack](https://img.shields.io/badge/slack-@kubernetes/fury-yellow.svg?logo=slack&label=Slack)

<!-- <KFD-DOCS> -->
**Kubernetes Fury Auth** provides Authentication Management for [Kubernetes Fury Distribution (KFD)][kfd-repo].

If you are new to KFD please refer to the [official documentation][kfd-docs] on how to get started with KFD.

## Overview

**Kubernetes Fury Auth** uses CNCF recommended, Cloud Native projects, such as [Dex][dex-repo] an identity provider, and [Pomerium][pomerium-repo] an identity-aware proxy to enable secure access to internal applications.

## Packages

Kubernetes Fury Auth provides the following packages:

| Package                                                | Version   | Description                                                                                                                                                |
| ------------------------------------------------------ | --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [pomerium](katalog/pomerium)                           | `v0.15.8` | Identity-aware proxy that enables secure access to internal applications.                                                                                  |
| [dex](katalog/dex)                                     | `v2.20.0` | OpenID Connect (OIDC) identity and OAuth 2.0 provider.                                                                                                     |
| [dex-k8s-authenticator](katalog/dex-k8s-authenticator) | `v1.1.0`  | A helper web-app which talks to one or more Dex Identity services to generate kubectl commands for creating and modifying a kubeconfig. (to be deprecated) |
| [gangway](katalog/gangway)                             | `v3.2.0`  | Enable authentication flows via OIDC for a kubernetes cluster  (to be deprected)                                                                           |

## Compatibility

| Kubernetes Version |   Compatibility    | Notes                                               |
| ------------------ | :----------------: | --------------------------------------------------- |
| `1.20.x`           | :white_check_mark: | No known issues                                     |
| `1.21.x`           | :white_check_mark: | No known issues                                     |
| `1.22.x`           | :white_check_mark: | No known issues                                     |
| `1.23.x`           |     :warning:      | Conformance tests passed. Not officially supported. |

Check the [compatibility matrix][compatibility-matrix] for additional information on previous releases of the modules.

## Usage

### Prerequisites

| Tool                        | Version   | Description                                                                                                                                                    |
| --------------------------- | --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [furyctl][furyctl-repo]     | `>=0.6.0` | The recommended tool to download and manage KFD modules and their packages. To learn more about `furyctl` read the [official documentation][furyctl-repo].     |
| [kustomize][kustomize-repo] | `>=3.5.0` | Packages are customized using `kustomize`. To learn how to create your customization layer with `kustomize`, please refer to the [repository][kustomize-repo]. |

### Deployment

1. List the packages you want to deploy and their version in a `Furyfile.yml`:

```yaml
versions:
    auth: "v0.1.0"
bases:
  - name: auth/pomerium
  - name: auth/dex
```

> See `furyctl` [documentation][furyctl-repo] for additional details about `Furyfile.yml` format.

2. Execute `furyctl vendor -H` to download the packages

3. Inspect the download packages under `./vendor/katalog/auth/`.

4. Define a `kustomization.yaml` that includes the `./vendor/katalog/auth` directory as a resource.

```yaml
resources:
- ./vendor/katalog/auth/pomerium
- ./vendor/katalog/auth/dex
```

5. Create the configuration file for Dex ([example](katalog/dex/dex.yml)) and add it as a secret to the `kustomization.yaml` file:

```yaml
secretGenerator:
  - name: dex
    files:
      "secrets/dex/config.yml"
```

⛔️ Follow the instructions in [pomerium's package readme](katalog/pomerium/README.md) before proceeding.

6. To deploy the packages to your cluster, execute:

```bash
kustomize build . | kubectl apply -f -
```

<!-- Links -->
[furyctl-repo]: https://github.com/sighupio/furyctl
[sighup-page]: https://sighup.io
[kfd-repo]: https://github.com/sighupio/fury-distribution
[kustomize-repo]: https://github.com/kubernetes-sigs/kustomize
[kfd-docs]: https://docs.kubernetesfury.com/docs/distribution/
[compatibility-matrix]: https://github.com/sighupio/fury-kubernetes-auth/blob/master/docs/COMPATIBILITY_MATRIX.md
[pomerium-repo]: https://github.com/pomerium/pomerium
[dex-repo]: https://github.com/dexidp/dex
<!-- </KFD-DOCS> -->

<!-- <FOOTER> -->
## Contributing

Before contributing, please read first the [Contributing Guidelines](docs/CONTRIBUTING.md).

### Reporting Issues

In case you experience any problem with the module, please [open a new issue](https://github.com/sighupio/fury-kubernetes-auth/issues/new/choose).

## License

This module is open-source and it's released under the following [LICENSE](LICENSE)
<!-- </FOOTER> -->

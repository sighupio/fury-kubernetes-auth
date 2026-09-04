# Auth Module Release vX.Y.Z

Welcome to the latest release of the Auth module for the SIGHUP Distribution.

## Included packages

| Package     | Current Version                                                        | Previous Version |
| ----------- | ---------------------------------------------------------------------- | ---------------- |
| `dex`       | [`v2.45.1`](https://github.com/dexidp/dex/releases/tag/v2.45.1)        | `v2.45.1`        |
| `gangplank` | [`v1.2.1`](https://github.com/sighupio/gangplank/releases/tag/v1.2.1)  | `v1.2.1`         |
| `pomerium`  | [`v0.32.7`](https://github.com/pomerium/pomerium/releases/tag/v0.32.7) | `v0.32.7`        |

## Compatibility

This release maintains compatibility with Kubernetes versions 1.29.x through 1.35.x.

## Update Guide 🦮

### Process

To upgrade this module, you need to download this new version, then apply the `kustomize`
project.

```bash
kustomize build | kubectl apply -f -
```

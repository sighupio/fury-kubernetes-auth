# Dex Package Maintenance Guide

To update the Dex package, follow the next steps:

1. Download the sample manifests from upstream, <https://github.com/dexidp/dex/blob/master/examples/k8s/dex.yaml>.
2. Compare them with the manifests in this folder.
3. Port the needed changes
4. Update the image tag
5. Sync the image to our repository

## Customizations

- Splitted the sample manifest into several files.
- Deleted the environment variables for GitHubn authentication from the upsteam example.
- Added the `metrics` port to the deployment
- Dex gets deployed into the `kube-system` namespace instead of `dex`

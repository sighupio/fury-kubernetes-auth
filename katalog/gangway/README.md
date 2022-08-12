# Gangway

<!-- <KFD-DOCS> -->

Gangway is an application that can be used to easily enable authentication flows via OIDC for a Kubernetes cluster.

Kubernetes supports OpenID Connect Tokens as a way to identify users who access the cluster. Gangway allows users to self-configure their kubectl configuration in a few short steps.

> ℹ️ Learn more about Gangway in the [official repository](https://github.com/vmware-archive/gangway) and in the [official documentation](https://github.com/vmware-archive/gangway/blob/master/docs/README.md).

## Requirements

- Kubernetes >= `1.18.0`
- Kustomize >= `v3`

## Image repository and tag

- Gangway repository: <https://github.com/vmware-archive/gangway>
- Gangway container image: `gcr.io/heptio-images/gangway:v3.2.0`

## Configuration

Gangway is configured using a `gangway.yml` file. You can find a [sample configuration file here](example/gangway.yml).

Notice that to enable Gangway to communicate with Dex you need to add the required configuration under `staticClients` section.

Once you have written your configuration file, create a Kubernetes secret named `gangway` in the `kube-system` namespace with the contents of the configuration file under the `gangway.yml` key.

> ℹ️ We recommend you do this using Kustomize, either with a `secretGenerator` or as a resource.

The `gangway` secret will then be mounted by the deployment as a volume in the right path.

## Deployment

Once you have created the configuration file, you can deploy Gangway by running the following command in the folder of this package:

```shell
kustomize build | kubectl apply -f -
```

## License

For license details please see [LICENSE](https://sighup.io/fury/license)

<!-- </KFD-DOCS> -->

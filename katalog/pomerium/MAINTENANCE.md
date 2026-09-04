# Pomerium Package Maintenance Guide

Upstream documentation is located at: <https://www.pomerium.com/docs/>
Upgrade docs are here: <https://www.pomerium.com/docs/overview/upgrading>

> ⚠️ Notice that the component that we deploy is "Pomerium" all-in-one and not the Pomerium Ingress Controller. We use Pomerium only in proxy mode to auth the Ingress requests.

Releases of Pomerium can be found at: <https://github.com/pomerium/pomerium>

Here are some examples for Kubernetes deployments: <https://github.com/pomerium/pomerium/tree/main/examples/kubernetes>

## Update

To update the Pomerium package, follow the next steps:

1. The manifests for Pomerium are custom, there is no upstream to follow. Read carefully the release notes from upstream and adjust the manifests.
2. Update the documentation.
3. Sync the new image tag to SD's registry.

### Things to know about the image

- We deploy the `nonroot-` image variant, and the manifests pin `runAsUser`/`runAsGroup` to
  `65532` with `readOnlyRootFilesystem: true`. Check those still hold after a base image
  change: Envoy needs a writable temp dir, which is why `/tmp` is an `emptyDir`.
- Starting from `v0.33.1` the upstream images are based on distroless `base-nossl`. That
  variant still ships `ca-certificates` (so validating an IdP served by a public CA works)
  but it does not ship `libssl`. Pomerium's bundled Envoy links BoringSSL statically, so
  this is fine, but it is worth re-checking on any future base image change.
- The readiness/liveness probes hit `/ping` over plain HTTP, so they will **not** catch a
  broken TLS stack. Use the E2E suite's OIDC flow test to validate that instead: it exercises
  Pomerium's back-channel TLS call to Dex through the CA mounted at `/certs/ca.crt`.

### Envoy header limits

Pomerium embeds Envoy, so Envoy's header limits apply to every request Pomerium proxies.
Since the fix for CVE-2026-47774 (Envoy `1.36.8`, shipped in Pomerium `v0.32.9`), cookie
header bytes count towards Envoy's header map limits — by default 100 headers and 60 KB
total. Deployments whose users carry many or very large cookies on the domain can see
requests reset. Upstream raised the built-in limits in `v0.32.9` and `v0.33.0`. Note that
`katalog/pomerium/ingress.yml` also sets `nginx.ingress.kubernetes.io/proxy-buffer-size: 16k`
for the same class of problem; if large-header failures show up after an upgrade, both limits
are worth looking at.

### Monitoring

There are 2 grafana dashboards included:

1. `pomerium.json`: this is a hand-made dashboard using the metrics exposed by pomerium that start with `pomerium_*`. Feel free to edit and improve it.
2. `envoy.json`: this dashbaord has been taken from Grafana's marketplace: <https://grafana.com/grafana/dashboards/11022-envoy-global/>. The title has been edited and a tag `pomerium` addded to the dashboard.

# Pomerium

<!-- <KFD-DOCS> -->

Pomerium is an identity-aware proxy that enables secure access to internal applications. Pomerium provides a standardized interface to add access control to applications regardless of whether the application itself has authorization or authentication baked-in

## Pomerium Setup

This document is intended to give a brief overview of how Pomerium can be implemented, for further details, please look at the [official documentation][pomerium-docs].

### Deploy

The base kustomization file present [here](./kustomization.yaml) allows you to quickly integrate Pomerium in proxy auth mode with an existing Dex service that could, for example, be connected to an LDAP backend.

To do so, you will need to edit your Dex configuration, adding a static client to be used by Pomerium, like in the example below:

```yaml
>>staticClients:
    - id: "pomerium-auth-client"
      secret: "your-super-secret"
      name: "Pomerium"
      redirectURIs:
       - "https://pomerium.example.com/oauth2/callback"
```

> ⚠️ Configure the `redirectURIs` section accordingly to the hosts used for the pomerium ingress.
<!-- space intentionally left blank -->
> See [Dex official documentation][dex-docs] for more details.

Once Dex is configured correctly, you will need to override the configuration example ([policy](./config/policy.example.yaml) and environment variables via a [configmap](./config/config.example.env) and [secret](secrets/pomerium.example.env)) in your `kustomization.yaml` file like in the example below:

```yaml
configMapGenerator:
  - name: pomerium-policy
    behavior: replace
    files:
      - policy.yml=config/pomerium-policy.yml
  - name: pomerium
    behavior: replace
    envs:
      - config/pomerium-config.env

secretGenerator:
  - name: pomerium-env
    behavior: replace
    envs:
      - secrets/pomerium.env
```

> 💡 You can copy the examples in the module (see [1](config/config.example.env), [2](config/policy.example.yaml), and [3](secrets/pomerium.example.env)) and override them according to your settings.

**⚠ WARNING: in the policy file, you'll need to set up a route for each ingress you want to protect with Pomerium authorization service.**

### Ingresses

Once Pomerium and Dex are correctly configured, the last step is to create an Ingress with the hostname to expose your application **in Pomerium's namespace** pointing to Pomerium's service, for example:

```yaml
---
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  annotations:
    forecastle.stakater.com/expose: "true"
    forecastle.stakater.com/appName: "Prometheus"
    forecastle.stakater.com/icon: "https://github.com/stakater/ForecastleIcons/raw/master/prometheus.png"
    kubernetes.io/tls-acme: "true"

  name: prometheus
  namespace: pomerium
spec:
  ingressClassName: internal  # or external, or nginx.
  rules:
    - host: prometheus.example.com
      http:
        paths:
          - path: /
            backend:
              service:
                name: pomerium  # notice: pomerium, not prometheus
                port:
                  name: http
  tls:
    - hosts:
        - prometheus.example.com
      secretName: prometheus-tls
```

Now if you access `http(s)://prometheus.example.com` you'll be forwarded to the Dex login page and if the user is authorized the application will be proxied by Pomerim accordingly with the rules set in your policy.

<!-- Links -->
[pomerium-docs]: https://www.pomerium.io/docs/
[dex-docs]: https://dexidp.io/docs/kubernetes/

<!-- </KFD-DOCS> -->

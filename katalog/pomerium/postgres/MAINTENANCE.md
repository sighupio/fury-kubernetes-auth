# Postgres

Upstream documentation is located at: <https://github.com/bitnami/charts/tree/main/bitnami/postgresql>

> ⚠️ Notice that the component that we deploy is "Postgres" solution via the official Bitnami chart.

Releases of Postgres chart can be found in the official CHANGELOG: <https://github.com/bitnami/charts/tree/main/bitnami/postgresql>

## Update

To update the Postgres package, follow the next steps:

1. The manifests for Pomerium are taken by the official bitnami chart. Follow the **CHANGELOG** for checking the braking change and update the image tag accordingly. To generate the yaml file via helm:

```bash
helm template postgres bitnami/postgresql --set auth.postgresPassword=<random_password> --set image.tag=<official_postgres_image>  --set primary.persistence.enabled=false > postgres.yml
```

For the password any random string of 32 chars like in the example below:

```bash
pwgen -1 32 -c
```

2. Update the documentation.

# Dex Package Maintenance Guide

To update the Dex package, follow the next steps.

Run the following commands:

```bash
helm repo add dex https://charts.dexidp.io
helm repo update
helm template dex dex/dex -n kube-system --set serviceMonitor.enabled=true > dex-built.yml
```

With the `dex-built.yml` file, check differences with the current `deploy.yml` file and change accordingly.

## Customizations

What was customized (what differs from the helm template command):

- Simplified the labels
- Changed metrics port name from `telemetry` to `metrics`
- Simplified container command
- Changed configuration path
- Added resources and limits
- Added interval `30s` to ServiceMonitor
- Removed secret, since it's custom for each dex deploy
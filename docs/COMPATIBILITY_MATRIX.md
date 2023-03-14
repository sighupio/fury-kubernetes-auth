
# Compatibility Matrix

| Module Version / Kubernetes Version |       1.20.X       |       1.21.X       |       1.22.X       | 1.23.X             | 1.24.X             | 1.25.X             |
| ----------------------------------- | :----------------: | :----------------: | :----------------: | ------------------ | ------------------ | ------------------ |
| v0.0.1                              | :white_check_mark: |     :warning:      |        :x:         | :x:                | :x:                |                    |
| v0.0.2                              |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |
| v0.0.3                              |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |

:white_check_mark: Compatible

:warning: Has issues

:x: Incompatible

## Warnings

- Provided version of `Dex` in v0.0.1 is not compatible with Kubernets 1.21 out of the box. It needs a patch with the pod's namespace as an environment variable.

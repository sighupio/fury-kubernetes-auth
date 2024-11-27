#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -e

echo "> Checking for Kapp and installing if missing"

# Check if kapp is already installed
if command -v kapp &> /dev/null; then
    echo "Nothing to do. Kapp is already installed."
    exit 0
fi

# Define the kapp version
KAPP_VERSION="v0.63.3"
# Determine OS and architecture
OS=$(uname -s)
ARCH=$(uname -m)
echo "Detected operating system: ${OS}"
echo "Detected architecture: ${ARCH}"

# Prepare the download URL based on OS and architecture
URL=""
case "${OS}" in
    Linux|Darwin)
        case "${ARCH}" in
            x86_64|amd64) SUFFIX="amd64" ;;
            arm|arm64) SUFFIX="arm64" ;;
            *) echo "Architecture ${ARCH} is not supported."; exit 1 ;;
        esac
        URL="https://github.com/carvel-dev/kapp/releases/download/${KAPP_VERSION}/kapp-${OS}-${SUFFIX}"
        ;;
    *)
        echo "Operating system ${OS} is not supported."; exit 1 ;;
esac

# Download and setup kapp
echo "Downloading kapp from ${URL}..."
curl -LO "${URL}"

# Move the binary in to your PATH
mv "kapp-${OS}-${SUFFIX}" /usr/local/bin/kapp

# Make the binary executable
chmod +x /usr/local/bin/kapp

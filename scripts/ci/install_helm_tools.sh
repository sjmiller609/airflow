#!/bin/bash
set -e

if [[ -z "${KIND_VERSION}" ]]; then
  export KIND_VERSION="0.7.0"
fi

if [[ -z "${HELM_VERSION}" ]]; then
  export HELM_VERSION="3.1.2"
fi

# Determine the platform we are running on
OS=$(uname | tr '[:upper:]' '[:lower:]')

# Set up a bin location
mkdir -p /tmp/bin
PATH=/tmp/bin:$PATH
# Save our current directory so we can come back
CURRENT_DIR=$(pwd)
cd /tmp

echo "Installing Kubernetes in Docker (kind) version ${KIND_VERSION}..."
if [[ -f /tmp/bin/kind ]]; then
  echo "Already installed in /tmp/bin. Skipping!"
else
  curl -Lo ./kind https://github.com/kubernetes-sigs/kind/releases/download/v${KIND_VERSION}/kind-${OS}-amd64 > /dev/null 2>&1
  chmod +x ./kind
  mv ./kind /tmp/bin/
fi

echo "Installing Helm version ${HELM_VERSION}..."
if [[ -f /tmp/bin/helm ]]; then
  echo "Already installed in /tmp/bin. Skipping!"
else
  wget https://get.helm.sh/helm-v${HELM_VERSION}-${OS}-amd64.tar.gz > /dev/null 2>&1
  tar -zxvf ./helm-v${HELM_VERSION}-${OS}-amd64.tar.gz
  mv ${OS}-amd64/helm /tmp/bin/
fi

echo "Installing the latest, stable kubectl..."
if [[ -f /tmp/bin/kubectl ]]; then
  echo "Already installed in /tmp/bin. Skipping!"
else
  cd /tmp/bin
  curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/${OS}/amd64/kubectl > /dev/null 2>&1
  chmod +x ./kubectl
fi

cd $CURRENT_DIR

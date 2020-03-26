#! /usr/bin/env bash

if [[ -z "${KUBE_VERSION}" ]]; then
  export KUBE_VERSION='1.15.6'
fi

# Create a kind cluster
kind create cluster --image kindest/node:v${KUBE_VERSION}
# I have found kind create cluster
# fails rarely, but since we are running
# many in parallel, that it happens
# enough to justify a retry
if ! [[ $? -eq 0 ]]; then
  echo "Failed to create Kind cluster, trying one more time"
  kind delete cluster || true
  kind create cluster --image kindest/node:${KUBE_VERSION}
  if ! [[ $? -eq 0 ]]; then
    exit 1
  fi
fi

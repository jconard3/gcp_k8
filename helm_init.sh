#!/usr/bin/env bash

kubectl config use-context gke_main-183300_us-east1-b_main

if [ ! -f /usr/local/bin/helm ]; then
  brew install kubernetes-helm
fi

helm init
helm update

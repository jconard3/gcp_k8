#!/usr/bin/env bash

kubectl apply -f namespace.yaml
kubectl config set-context gke_main-183300_us-east1-b_main --cluster=gke_main-183300_us-east1-b_main --namespace=vpn
kubectl config use-context gke_main-183300_us-east1-b_main

if [ ! -f /usr/local/bin/helm ]; then
  brew install kubernetes-helm
fi
helm init
helm repo update

helm install stable/openvpn --version 2.0.0 -n vpn

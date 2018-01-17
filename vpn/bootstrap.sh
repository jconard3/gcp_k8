#!/usr/bin/env bash

kubectl config use-context gke_main-183300_us-east1-b_main
kubectl apply -f namespace.yaml
kubectl config set-context gcp_main_vpn --cluster=gke_main-183300_us-east1-b_main --user=gke_main-183300_us-east1-b_main --namespace=vpn
kubectl config use-context gcp_main_vpn

helm install stable/openvpn --version 2.0.0 -n vpn

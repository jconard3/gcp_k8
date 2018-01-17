#!/usr/bin/env bash

kubectl config use-context gke_main-183300_us-east1-b_main
kubectl create -f namespace.yaml
kubectl config set-context gcp_main_vault --cluster=gke_main-183300_us-east1-b_main --user=gke_main-183300_us-east1-b_main --namespace=vault
kubectl config use-context gcp_main_vault

helm install --name consul stable/consul \
  --set DatacenterName=main

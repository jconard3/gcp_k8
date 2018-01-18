#!/usr/bin/env bash

set -e
set -x

kubectl config use-context gke_main-183300_us-east1-b_main
kubectl create -f namespace.yaml
kubectl config set-context gcp_main_vault --cluster=gke_main-183300_us-east1-b_main --user=gke_main-183300_us-east1-b_main --namespace=vault
kubectl config use-context gcp_main_vault

helm install --name backend stable/consul \
  --set DatacenterName=main

while [[ $(kubectl get statefulset -l 'release=backend' -o jsonpath='{.items[0].status.replicas}') != $(kubectl get statefulset -l 'release=backend' -o jsonpath='{.items[0].status.readyReplicas}') ]]
do
  echo "Waiting for backend-consul pods to become ready."
  sleep 10
done

helm install --name frontend incubator/vault \
  --set vault.dev=false,vault.config.storage.consul.address="backend-consul:8500",vault.config.storage.consul.path="vault"

while [[ $(kubectl get replicaset -l 'release=frontend' -o jsonpath='{.items[0].status.replicas}') != $(kubectl get replicaset -l 'release=frontend' -o jsonpath='{.items[0].status.readyReplicas}') ]]
do
  echo "Waiting for frontend-vault pods to become ready."
  sleep 10
done

kubectl port-forward $(kubectl get pods -l "app=vault" -o jsonpath="{.items[0].metadata.name}") 8200:8200 &>/dev/null &
export VAULT_ADDR=http://127.0.0.1:8200

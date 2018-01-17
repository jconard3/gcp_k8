#!/usr/bin/env bash
kubectl config use-context gke_main-183300_us-east1-b_main
kubectl create -f namespace.yaml
kubectl config set-context gcp_main_wedding --cluster=gke_main-183300_us-east1-b_main --namespace=wedding
kubectl config use-context gcp_main_wedding

helm install --name wedding-website \
  --set wordpressUsername=jconard,wordpressEmail=jordan.conard3@gmail.com,wordpressFirstName=Jordan,wordpressLastName=Conard,wordpressBlogName="Amanda and Jordan's Wedding Website" \
  stable/wordpress

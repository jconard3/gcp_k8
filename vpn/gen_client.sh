#!/usr/bin/env bash

# Script taken from https://kubeapps.com/charts/stable/openvpn

if [ $# -ne 1 ]
then
  echo "Usage: $0 <CLIENT_KEY_NAME>"
  exit
fi

MY_CONTEXT="gke_main-183300_us-east1-b_main"
CONTEXT=$(kubectl config current-context)
if [ $CONTEXT != $MY_CONTEXT ]; then
  kubectl config use-context ${MY_CONTEXT}
fi

NAMESPACE=$(kubectl get pods --all-namespaces -l type=openvpn -o jsonpath='{.items[0].metadata.namespace}')
if [ $NAMESPACE != "vpn" ]; then
  kubectl config set-context ${MY_CONTEXT} --cluster=${MY_CONTEXT} --namespace=vpn
fi

KEY_NAME=$1
POD_NAME=$(kubectl get pods -n $NAMESPACE -l type=openvpn -o jsonpath='{.items[0].metadata.name}')
SERVICE_NAME=$(kubectl get svc -n $NAMESPACE -l type=openvpn  -o jsonpath='{.items[0].metadata.name}')
SERVICE_IP=$(kubectl get svc -n $NAMESPACE $SERVICE_NAME -o go-template='{{range $k, $v := (index .status.loadBalancer.ingress 0)}}{{$v}}{{end}}')
kubectl -n $NAMESPACE exec -it $POD_NAME /etc/openvpn/setup/newClientCert.sh $KEY_NAME $SERVICE_IP
kubectl -n $NAMESPACE exec -it $POD_NAME cat /etc/openvpn/certs/pki/$KEY_NAME.ovpn > $KEY_NAME.ovpn

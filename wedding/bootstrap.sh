kubectl create -f namespace.yaml
kubectl config set-context gke_main-183300_us-east1-b_main --cluster=gke_main-183300_us-east1-b_main --namespace=wedding
kubectl config use-context gke_main-183300_us-east1-b_main

helm init
helm repo update

helm install --name wedding-website \
  --set wordpressUsername=jconard,wordpressEmail=jordan.conard3@gmail.com,wordpressFirstName=Jordan,wordpressLastName=Conard,wordpressBlogName="Amanda and Jordan's Wedding Website" \
  stable/wordpress

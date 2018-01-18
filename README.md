# gcp_k8
Repo of scripts and kubernetes manifests to manage my k8 lab hosted in GCP

Scripts pick up after k8 cluster has been created in GCP. `helm_init.sh` starts the installation of the local helm client and continues with installing the tiller on the hosted k8 cluster. Note all bash scripts have my k8 cluster hardcoded. This is an easily fixable todo when/if I get around to it.

Each subdirectory contains a bootstrap bash script that creates the appropriate namespace on the cluster and then installs and configures the appropriate helm chart.

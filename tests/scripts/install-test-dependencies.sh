#!/bin/bash

set -e

KUBECTEL_VERSION=v1.13.0
MINIKUBE_VERSION=v0.35.0
TERRAFORM_VERSION=0.11.14

echo "> Installing kubectl..."
wget -O/tmp/kubectl "https://storage.googleapis.com/kubernetes-release/release/${KUBECTEL_VERSION}/bin/linux/amd64/kubectl"
chmod +x /tmp/kubectl
sudo cp /tmp/kubectl /usr/local/bin/kubectl

echo "> Installing minikube..."
wget -O/tmp/minikube "https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION}/minikube-linux-amd64"
chmod +x /tmp/minikube
sudo cp /tmp/minikube /usr/local/bin/minikube

echo "> Installing terraform..."
wget -O/tmp/terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
(cd /tmp && unzip /tmp/terraform.zip)
chmod +x /tmp/terraform
sudo cp /tmp/terraform /usr/local/bin/terraform

#mkdir -p "${HOME}/.kube" "${HOME}/.minikube"

echo "> Starting minikube..."
sudo minikube start --vm-driver=none --kubernetes-version=v1.13.0 
sudo chown -R travis: "${HOME}/.minikube/"

echo "> Installing terratest modules..."
go get github.com/gruntwork-io/terratest/modules/k8s
go get github.com/gruntwork-io/terratest/modules/terraform

# Verify kube-addon-manager.
# kube-addon-manager is responsible for managing other kubernetes components, such as kube-dns, dashboard, storage-provisioner..
JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'; 
until kubectl -n kube-system get pods -lcomponent=kube-addon-manager -o jsonpath="$JSONPATH" 2>&1 | grep -q "Ready=True"; do
  sleep 1
  echo "waiting for kube-addon-manager to be available"
  kubectl get pods --all-namespaces
done

# Wait for kube-dns to be ready.
JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'
until kubectl -n kube-system get pods -lk8s-app=kube-dns -o jsonpath="$JSONPATH" 2>&1 | grep -q "Ready=True"; do 
  sleep 1
  echo "waiting for kube-dns to be available"
  kubectl get pods --all-namespaces
done
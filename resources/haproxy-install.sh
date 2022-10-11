#!/bin/bash

# install microk8s
sudo snap install microk8s --classic
# allow pod-to-pod and pod-to-internet communication
sudo ufw allow in on cni0 && sudo ufw allow out on cni0
sudo ufw default allow routed
# give current user access to microk8s
sudo usermod -a -G microk8s $USER
sudo chown -f -R ubuntu ~/.kube
# exit ssh session and reconnect to activate new changes
# enable dns hostpath-storage Addons
microk8s enable dns hostpath-storage
# configure kubectl alias to microk8s kubectl
sudo snap alias microk8s.kubectl kubectl
# configure runboat kubernetes name spaces
# create runboat-builds namespaces
microk8s kubectl apply -f namespace.yaml
# install haproxy-ingress
microk8s helm repo add haproxy-ingress https://haproxy-ingress.github.io/charts
microk8s helm upgrade haproxy-ingress haproxy-ingress/haproxy-ingress\
  --install\
  --create-namespace --namespace ingress-controller\
  --version 0.13.9\
  -f haproxy-ingress-values.yaml
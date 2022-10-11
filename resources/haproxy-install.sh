#!/bin/bash

# enable dns hostpath-storage Addons
microk8s enable dns hostpath-storage
# configure kubectl alias to microk8s kubectl
sudo snap alias microk8s.kubectl kubectl
# create runboat-builds namespaces
microk8s kubectl apply -f namespace.yaml
# install haproxy-ingress
microk8s helm repo add haproxy-ingress https://haproxy-ingress.github.io/charts
microk8s helm upgrade haproxy-ingress haproxy-ingress/haproxy-ingress\
  --install\
  --create-namespace --namespace ingress-controller\
  --version 0.13.9\
  -f haproxy-ingress-values.yaml
#!/bin/bash

# install microk8s
sudo snap install microk8s --classic

# allow pod-to-pod and pod-to-internet communication
sudo ufw allow in on cni0 && sudo ufw allow out on cni0
sudo ufw default allow routed

# give current user access to microk8s
sudo usermod -a -G microk8s $USER
sudo chown -f -R ubuntu ~/.kube
# exit ssh session and reconnect to activate these changes
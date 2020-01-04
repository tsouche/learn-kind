#!/bin/bash
VERSION=v2.0.0-beta8

# BEWARE - version compatibility matters.
# Since kind is running on Kubernetes v1.15, I had to:
#   - install an older version of kubectl (1.15.17)
#       snap install kubectl --channel=1.15/stable
#   - copy the dashboard YAML file v2.0.0-beta4 which is compatible with 
#       Kubernetes v1.15:
#       * kubernetesui/dashboard:v2.0.0-beta4
#       * kubernetesui/metrics-scraper:v1.0.1
#       https://github.com/kubernetes/dashboard/releases/tag/v2.0.0-beta4

echo "==============================="
echo "Installing Kubernetes Dashboard"
echo "==============================="

# retrieve the yaml file with the proper version 
curl -Lo /projects/learn-kind/dashboard-$(echo $VERSION)-recommended.yaml https://raw.githubusercontent.com/kubernetes/dashboard/$VERSION/aio/deploy/recommended.yaml

echo "Installing Kubernetes Dashboard"
kubectl apply -f /projects/learn-kind/dashboard-$(echo $VERSION)-recommended.yaml

echo "Create sample user with the right to access the dashboard"
if [ -f /projects/learn-kind/dashboard-adminuser.yaml ]
then
    kubectl apply -f /projects/learn-kind/dashboard-adminuser.yaml
fi

# Wait 5 seconds to give time for teh dashboard to be deployed and the user to 
# be created
sleep 5

# Grep the secret and use it to login on the browser
echo "Get Token"
kubectl -n kubernetes-dashboard describe secret "$(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')"

echo "Start kube proxy in another tab of the existing terminal"
gnome-terminal bash --tab -- kubectl proxy -p 8080

echo "Launch dashboard in a web browser"
xdg-open http://localhost:8080/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/


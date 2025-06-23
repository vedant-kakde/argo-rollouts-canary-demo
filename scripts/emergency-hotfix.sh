#!/bin/bash
set -e
NAMESPACE=canary-demo

function header() {
  echo -e "\n========== $1 =========="
}

header "Deploying Emergency Hotfix (100% traffic)"
kubectl apply -f manifests/deployment-hotfix.yaml -n $NAMESPACE

header "Verifying Pods"
kubectl get pods -n $NAMESPACE -l app=fastapi-hotfix

header "Service Info"
kubectl get svc -n $NAMESPACE

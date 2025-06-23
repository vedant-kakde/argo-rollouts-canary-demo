#!/bin/bash
set -e
NAMESPACE=canary-demo
ROLLOUT=fastapi-rollout

function header() {
  echo -e "\n========== $1 =========="
}

header "Start: Initial rollout status"
kubectl argo rollouts get rollout $ROLLOUT -n $NAMESPACE

header "Promoting to 5%"
kubectl argo rollouts promote $ROLLOUT -n $NAMESPACE
sleep 10

header "Promoting to 25%"
kubectl argo rollouts promote $ROLLOUT -n $NAMESPACE
sleep 10

header "Promoting to 50%"
kubectl argo rollouts promote $ROLLOUT -n $NAMESPACE
sleep 10

header "Simulating failure — triggering rollback"
kubectl argo rollouts abort $ROLLOUT -n $NAMESPACE
sleep 5

header "Final rollout status"
kubectl argo rollouts get rollout $ROLLOUT -n $NAMESPACE

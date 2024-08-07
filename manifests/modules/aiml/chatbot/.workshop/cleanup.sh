#!/bin/bash

set -e

logmessage "Deleting AIML resources..."

kubectl delete namespace llama2 --ignore-not-found

kubectl delete svc -n gradio-llama2-inf2 gradio-nlb --ignore-not-found

kubectl delete namespace gradio-llama2-inf2 --ignore-not-found

uninstall-helm-chart aws-load-balancer-controller kube-system

logmessage "Deleting Karpenter NodePool and EC2NodeClass..."

delete-all-if-crd-exists nodepools.karpenter.sh
delete-all-if-crd-exists ec2nodeclasses.karpenter.k8s.aws

logmessage "Waiting for Karpenter nodes to be removed..."

EXIT_CODE=0

timeout --foreground -s TERM 30 bash -c \
    'while [[ $(kubectl get nodes --selector=type=karpenter -o json | jq -r ".items | length") -gt 0 ]];\
    do sleep 5;\
    done' || EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
  logmessage "Warning: Karpenter nodes did not clean up"
fi
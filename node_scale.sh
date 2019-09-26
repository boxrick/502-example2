#!/bin/bash

# vars
project=example
deploy_name=helloweb-deployment
cluster_name=examplecluster

i=0

while :
do
  let "i=i+1"
  if [ $((i%2)) -eq 0 ];
  then
      echo "Scaling up - Cycle ${i}";
      # kubectl scale --replicas=15 deployment/helloweb-deployment
      gcloud -q container clusters resize ${cluster_name} --node-pool standard-1 --size 4 --project ${project} --region europe-west1-c
      kubectl patch deployment ${deploy_name} -p "{\"spec\": {\"template\": {\"metadata\": { \"labels\": {  \"redeploy\": \"$(date +%s)\"}}}}}"
  else
      echo "Scaling down - Cycle ${i}";
      gcloud -q container clusters resize ${cluster_name}  --node-pool standard-1 --size 3 --project ${project} --region europe-west1-c
      kubectl patch deployment ${deploy_name} -p "{\"spec\": {\"template\": {\"metadata\": { \"labels\": {  \"redeploy\": \"$(date +%s)\"}}}}}"
      # kubectl scale --replicas=5 deployment/helloweb-deployment
  fi
	sleep 60
  # kubectl patch deployment ${deploy_name} -p "{\"spec\": {\"template\": {\"metadata\": { \"labels\": {  \"redeploy\": \"$(date +%s)\"}}}}}"
  # sleep 60
done

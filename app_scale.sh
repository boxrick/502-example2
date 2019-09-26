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
      kubectl scale --replicas=15 deployment/${deploy_name}
  else
      echo "Scaling down - Cycle ${i}";
      kubectl scale --replicas=6 deployment/${deploy_name}
  fi
	sleep 45
      kubectl patch deployment ${deploy_name} -p "{\"spec\": {\"template\": {\"metadata\": { \"labels\": {  \"redeploy\": \"$(date +%s)\"}}}}}"
  sleep 45
done

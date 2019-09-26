# 502 example repo

A short repo which demonstrates 502s with Apache / PHP Docker image in GKE.

## Process

* Create cluster with cluster create command

```
gcloud config set project
gcloud config set compute/zone europe-west1-c
gcloud container clusters create loadbalancedcluster
gcloud container clusters get-credentials loadbalancedcluster --zone europe-west1-c --project example-project
```

* Edit deployment to have relevent DNS endpoint

`./kubernetes/ingress:42`

* Create deployment in new cluster

`kubectl apply -f ./kubernetes/`

* Wait for ingress to be created and add DNS entry

`watch kubectl get ing helloweb-ingress -o 'custom-columns=ip:..status.loadBalancer.ingress[*].ip' --no-headers`

* Then wait for managed certificate to be provisioned ~10 mins

* Do 502 testing with siege and deployment

* Start siege load test tool
```siege -v --time=500H --internet --concurrent=10 https://helloweb.example.tk/ --user-agent="load-test" -H 'Accept-Encoding: gzip'```

* Trigger manual deployment
`kubectl patch deployment helloweb-deployment -p "{\"spec\": {\"template\": {\"metadata\": { \"labels\": {  \"redeploy\": \"$(date +%s)\"}}}}}"`

After a short period of time ~20-30 seconds a handful of 502s will appear
```
HTTP/1.1 200     2.01 secs:     288 bytes ==> GET  /
HTTP/1.1 200     6.51 secs:     288 bytes ==> GET  /
HTTP/1.1 200     6.52 secs:     288 bytes ==> GET  /
HTTP/1.1 502     9.01 secs:     332 bytes ==> GET  /
HTTP/1.1 200     2.01 secs:     288 bytes ==> GET  /
HTTP/1.1 502     9.00 secs:     332 bytes ==> GET  /
HTTP/1.1 502     9.00 secs:     332 bytes ==> GET  /
```

## Cleanup
* Remove deployment
```kubectl delete -f ./kubernetes```
* Remove DNS
* Delete Cluster
gcloud container clusters delete loadbalancedcluster

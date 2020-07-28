##
Run set-gke-cluster.sh script to setup GKE k8s cluster.

helm chart dir: ./app
Note: Having some issue in helm chart

We can run K8s resource using 1 file:
kubectl create -f myapp.yml

Currently App is running at http://34.70.73.109/

curl -i http://34.70.73.109/healthz

HTTP/1.1 200 OK
Server: nginx/1.15.10
Date: Tue, 28 Jul 2020 09:31:08 GMT
Content-Type: text/html
Content-Length: 0
Connection: keep-alive

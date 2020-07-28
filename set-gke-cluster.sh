gcloud auth login

echo "enable services"
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com

ZONE=$(gcloud compute zones list \
    --filter "region:(us-central1)" \
    | awk '{print $1}' \
    | tail -n 1)

ZONES=$(gcloud compute zones list \
    --filter "region:(us-central1)" \
    | tail -n +2 \
    | awk '{print $1}' \
    | tr '\n' ',')

#MACHINE_TYPE=n1-standard-1
CLUSTER_NAME=mycluster 

##Create cluster using default version
gcloud container clusters create $CLUSTER_NAME \
    --zone $ZONE

##Generate a kubeconfig entry
gcloud container clusters get-credentials $CLUSTER_NAME \
    --zone $ZONE

##Set Default cluster for kubectl
gcloud container clusters get-credentials $CLUSTER_NAME \
    --zone $ZONE


sudo yum update kubectl

kubectl create secret generic my-creds --from-env-file=.env

###Nginx Ingress https://kubernetes.github.io/ingress-nginx/deploy/
kubectl create clusterrolebinding \
    cluster-admin-binding \
    --clusterrole cluster-admin \
    --user $(gcloud config get-value account)

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/1cd17cd12c98563407ad03812aebac46ca4442f2/deploy/mandatory.yaml

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/1cd17cd12c98563407ad03812aebac46ca4442f2/deploy/provider/cloud-generic.yaml
	
	
##Install Helm
curl -o get_helm.sh https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get
chmod +x get_helm.sh
./get_helm.sh


###################
Install Helm
###################
echo "install helm"
# installs helm with bash commands for easier command line integration
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
# add a service account within a namespace to segregate tiller
kubectl --namespace kube-system create sa tiller
# create a cluster role binding for tiller
kubectl create clusterrolebinding tiller \
    --clusterrole cluster-admin \
    --serviceaccount=kube-system:tiller

echo "initialize helm"
# initialized helm within the tiller service account
helm init --service-account tiller
# updates the repos for Helm repo integration
helm repo update

echo "verify helm"
# verify that helm is installed in the cluster
kubectl get deploy,svc tiller-deploy -n kube-system

#######################
# Destroy the cluster #
#######################

gcloud container clusters \
    delete $CLUSTER_NAME \
    --zone $ZONE \
    --quiet

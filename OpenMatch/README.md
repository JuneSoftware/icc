# GCP

```
gcloud init
gcloud components install kubectl
gcloud config set compute/zone asia-south1-a
```

# Agones
## Cluster
### Firewall Configuration
```
gcloud compute firewall-rules create game-server-firewall --allow udp:7000-8000 --target-tags game-server --description "Firewall to allow game server udp traffic"
```

### KBE Cluster
```
gcloud container clusters create agones-cluster --tags=game-server --cluster-version=1.22 --zone=asia-south1-a --machine-type=c2-standard-4 --num-nodes=4 --scopes=gke-default --no-enable-autoupgrade
```

### Custom NodePool
```
gcloud container node-pools create agones-system --cluster=agones-cluster --no-enable-autoupgrade --node-taints agones.dev/agones-system=true:NoExecute --node-labels agones.dev/agones-system=true --num-nodes=1 --zone=asia-south1-a
```

## SDK

### Install Core
```
kubectl create namespace agones-system
kubectl apply -f https://raw.githubusercontent.com/JuneSoftware/Indus-Cloud-Orchestration/main/Agones/install.yaml
```

### Status
```
kubectl describe --namespace agones-system pods
kubectl get pods --namespace agones-system
```

### Delete Agones
```
kubectl delete -f https://raw.githubusercontent.com/JuneSoftware/Indus-Cloud-Orchestration/main/Agones/install.yaml
kubectl delete namespace agones-system
```


## GameServer

### Build Game Server Docker Image
```
docker build -t asia-south1-docker.pkg.dev/indus-staging-v1/linux-containers/game-server:v0.18.6_0 .
```

### Install Game Server
```
kubectl create -f https://raw.githubusercontent.com/JuneSoftware/Indus-Cloud-Orchestration/main/Agones/gameserver.yaml
```

### Get GameServer Status
```
kubectl get gameservers
kubectl describe gameserver
kubectl get gs
```

### Delete Game Server
```
kubectl delete gameservers --all --all-namespaces
```

## GameServerFleet


### Install GameServerFleet
```
kubectl create -f https://raw.githubusercontent.com/JuneSoftware/Indus-Cloud-Orchestration/main/Agones/fleet.yml
```

### Get GameServerFleet Status
```
kubectl get fleet
kubectl describe fleet indus-gameserver-fleet
```

### Scale GameServerFleet
```
kubectl scale fleet indus-gameserver-fleet --replicas=2
```

### Allocate GameServer from GameServerFleet
```
kubectl create -f https://raw.githubusercontent.com/googleforgames/agones/release-1.25.0/examples/simple-game-server/gameserverallocation.yaml -o yaml
```

### Delete GameServerFleet
```
kubectl delete fleets --all --all-namespaces
```

## OpenCert



# OpenMatch

### KBE Cluster
```
gcloud container clusters create open-match-cluster --tags=open-match --zone=asia-south1-a --machine-type=n2-standard-4 --num-nodes=2
```

### Install  Core
```
kubectl apply --namespace open-match  -f https://raw.githubusercontent.com/JuneSoftware/Indus-Cloud-Orchestration/main/OpenMatch/open_match_core.yaml
```

### Override Configs
```
kubectl apply --namespace open-match -f https://raw.githubusercontent.com/JuneSoftware/Indus-Cloud-Orchestration/main/OpenMatch/open_match_configmap_override.yaml -f https://raw.githubusercontent.com/JuneSoftware/Indus-Cloud-Orchestration/main/OpenMatch/open_match_evaluator.yaml
```

### Status
```
kubectl get -n open-match pod
kubectl get -n open-match services
```

### Delete
```
kubectl delete psp,clusterrole,clusterrolebinding --selector=release=open-match
kubectl delete namespace open-match
```

## Frontend

###  Upload to Artifact Registry
```
gcloud auth configure-docker asia-south1-docker.pkg.dev
docker push asia-south1-docker.pkg.dev/indus-staging-v1/linux-containers/indus-matchmaker-frontend:latest
```

### Deploy on same cluster as OpenMatch
```
kubectl create namespace indus-matchmaker
kubectl apply --namespace indus-matchmaker -f https://raw.githubusercontent.com/JuneSoftware/Indus-Cloud-Orchestration/main/OpenMatch/Frontend/frontend.yaml
```

## Mathfunction
###  Upload to Artifact Registry
```
gcloud auth configure-docker asia-south1-docker.pkg.dev
docker push asia-south1-docker.pkg.dev/indus-staging-v1/linux-containers/indus-matchmaker-function:latest
```

### Deploy on same cluster as OpenMatch
```
kubectl create namespace indus-matchmaker
kubectl apply --namespace indus-matchmaker -f https://raw.githubusercontent.com/JuneSoftware/Indus-Cloud-Orchestration/main/OpenMatch/MatchFunction/matchfunction.yaml
```


## Misc.


### Status
```
kubectl get -n indus-matchmaker pod
kubectl get -n indus-matchmaker services
```

### Delete
```
kubectl delete namespace indus-matchmaker
```

## General

###  Get All Pods
```
kubectl get pod -o=custom-columns=NODE:.spec.nodeName,NAME:.metadata.name --all-namespaces
```

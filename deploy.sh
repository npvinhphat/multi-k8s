# Build docker images and tag them
# There would be two tags: latest, and the git SHA in order for k8s
# to know there are changes and deployments need to be executed
docker build -t npvinhphat/multi-client:latest -t npvinhphat/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t npvinhphat/multi-server:latest -t npvinhphat/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t npvinhphat/multi-worker:latest -t npvinhphat/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# Take each of the image, and push to DockerHub
docker push npvinhphat/multi-client:latest
docker push npvinhphat/multi-server:latest
docker push npvinhphat/multi-worker:latest
docker push npvinhphat/multi-client:$SHA
docker push npvinhphat/multi-server:$SHA
docker push npvinhphat/multi-worker:$SHA


# Apply all k8s configs
kubectl apply -f k8s

# Imperatively set latest images on each deployment
kubectl set image deployments/client-deployment client=npvinhphat/multi-client:$SHA
kubectl set image deployments/server-deployment server=npvinhphat/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=npvinhphat/multi-worker:$SHA

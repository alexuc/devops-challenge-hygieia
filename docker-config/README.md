# Docker configuration
## by Alex U.

The purpose of this section is to define the attributes of the docker containers used for each of the nodes in the swarm. Unfortunately this section was not automated, by done mostly by CLI. In the intended solution, this section should include a set of .yml files specifying the container attributes. Other commands would need to be replaced by specific code portions in the Jenkins pipeline.

The commands used are:

1. Create the master node:

`sudo docker swarm init --advertise-addr 172.31.20.197`

2. Make all previously created nodes join the swarm, by running this command in each node:

`docker swarm join --token SWMTKN-1-1rykrfjdtibhls5mambi6y57sf9hccap71iv6sop9q96qwbc8i-8nwfnbjge754lur2p7guimzkj 172.31.20.197:2377`


## Other 1-time steps to setup Jenkins:
These are the commands needed to mount Jenkins in a new container running in the master:
1. Deploy a brand new Jenkins instance
`sudo docker stack deploy -c jenkins.yml jenkins`

Contents of jenkins.yml:
```
version: '3'
services:
main:
 image: jenkinsci/jenkins:${TAG:-lts-alpine}
 ports:
 - ${UI_PORT:-8080}:8080
 - ${AGENTS_PORT:-50000}:50000
 environment:
 - JENKINS_OPTS="--prefix=/jenkins"
```

2. Create a secret to authorize Jenkins nodes 

`sudo echo "-master http://172.31.20.197:8080/jenkins -password PASS -username USER"| sudo docker secret create jenkins-v1 -`

3. Login to Jenkins (http://swarm-master-ip:8080/jenkins) and complete the initial setup. Install all recommended plugins + Self-Organizing Swarm Plug-in Modules.

To obtain the admin initial password:

`docker service logs jenkins_main`

4. Configure Maven and Docker in Global tools settings.

5. Create the service that binds each node/container to the master in Jenkins

```
docker service create \
    --mode=global \
    --name jenkins-swarm-agent \
    -e LABELS=docker-prod \
    --mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" \
    --mount "type=bind,source=/tmp/,target=/tmp/" \
    --secret source=jenkins-v1,target=jenkins \
    vfarcic/jenkins-swarm-agent
```

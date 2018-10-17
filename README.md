# DevOps Challenge June 2018
## by Alex U.

This project contains the following elements:
* Terraform scripts to create 3 AWS EC2 nodes using a common VPC and keypair. This script will automatically provision a Chef cookbook (next item)
* Chef cookbook that provisions required artifacts by Hygieia application, including Java, Maven, Git, Docker, and required configuration for these components to work
* Docker commands to join the EC2 nodes into a Swarm
* Jenkins pipeline to build and deploy Hygieia application into Docker nodes

In each folder the details of every solution are provided.

# Solution approach
The proposed solution seeks to enable a CI/CD process for the development project Hygieia.
Although I was unable to complete the solution as I intended to do, I'd like to offer the train of thought
that led to this (half-done) solution.

In order to maintain the highest level of consistency and decoupling from code to host environment,
the approach is based on using ephemeral environments in each build. This is achieved in a swarm of Docker instances that
host each of the components of the Hygieia project in a microservices type of segmentation. There are four Docker nodes:
1. Master: Hosts a Jenkins instance that and leads the swarm. No application-specific code runs here, nor any build operation.
2. Node 1: Slave. Hosts the UI component of Hygieia
3. Node 2: Slave. Hosts the DB component of Hygieia
4. Node 3: Slave. Hosts the API and collector components of Hygieia

By separating the application in microservices, more trimmed build, deploy and test operations can be implemented, which reduces the
lead time to bugs/config issues, reduces wait on builds, and allows for teams specialization per system, etc.

All the environments are created using a Terraform script that automatically provisions all prerequisites based on a Chef cookbook.
This ensures consistency in environments creation. If we wanted to create another set of environments for staging or production, it'd be
just a matter of creating three more nodes using this script, and include them as nodes in Jenkins.

Finally, although I didn't implement anything of the Kubernetes cluster, in this solution I think we'd need to orchestrate the docker
nodes to allow for a much more enterprise-ready solution by opening posibilities of high availability, scalable deployment,
load balancing, self-healing, etc. For this, creating the environment through a Terraform script and provisioning it with a Chef cookbook
is an ideal option. Also, Jenkins would build and deploy to the nodes in the Kubernetes cluster.

So, what's missing in the implemented solution?
* Mainly the swarm of dockers, I wanted to orchestrate the whole build and deployment process from Jenkins, however I was unable to finish
the configuration of the dockers as nodes in Jenkins.
* Because the swarm of dockers was not completed, the Jenkinsfile that I wrote is not fully tested. I did the build/deploy operations
mostly through CLI but was unable to configure the pipeline properly.

As a final note, I'd like to thank you for reading through this, and for the opportunity to opt in in this challenge. Being totally
honest, most of these tools were unfamiliar for me, at least combined this way. It was a very enriching process for me that helped me
understand and learn about these technologies.
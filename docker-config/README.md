# DevOps Challenge June 2018
## by Alex U.

This project contains the following elements:
* Terraform scripts to create 3 AWS EC2 nodes using a common VPC and keypair. This script will automatically provision a Chef cookbook (next item)
* Chef cookbook that provisions required artifacts by Hygieia application, including Java, Maven, Git, Docker, and required configuration for these components to work
* Docker commands to join the EC2 nodes into a Swarm
* Jenkins pipeline to build and deploy Hygieia application into Docker nodes
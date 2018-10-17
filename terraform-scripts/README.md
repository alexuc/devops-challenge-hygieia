# Terraform creation of EC2 nodes
## by Alex U.

This script creates 3 EC2 CentOS nodes in a given AWS account. Teh script specifies the AMI, AWS zone, instance type, a fixed security group and VPC, and HD type and size. It also configures the necessary for Terraform to use a Chef provider to provision a cookbook that installs all necessary software in the VMs. This provisioner connects through SSH using a given client key, and executes a cookbook called "auc-docker-maven". It also installs Chef client in each node and registers them in hosted Chef using the provided account.
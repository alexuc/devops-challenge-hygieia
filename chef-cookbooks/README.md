# Chef Cookbook
## by Alex U.

The cookbook included (only one default recipe) provisions the following elements:
* Java RE v 1.8
* Maven 3.4
* Git
* Docker and configures it as a service
* Docker compose
* Sets special permissions for docker daemon in swarm mode
* All other dependencies in each of these packages

This cookbook is invoked automatically by Terraform at the moment of VMs creation. The Terraform Chef provisioner also installs Chef client.
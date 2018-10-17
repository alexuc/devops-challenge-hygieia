# Jenkins pipeline
## by Alex U.

This a very basic and unfinished pipeline in Jenkins that intends to cover the following stages:
* Initialize all the needed artifacts for the process to run
* Fetch the necessary code from SCM
* Build the application using Maven
* Build a docker image containing the Maven build output
* Deploy the app to a container

What's missing in this pipeline, is the split build/deploy to separate nodes based on their role in the swarm. This way, the application would be composed by microservices that can be quickly build and deployed in an ephemeral container. Also, this is missing the testing stage, at least some basic smoke test can be included.
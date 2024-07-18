# YelpCamp (3 tier architecture) deployment with Docker and GKE

This project demonstrates deploying YelpCamp application, a full-stack website for campground reviews, with a 3-tier architecture across various environments (`test`, `dev`, `prod`) using Cloud DevOps practices.

## Project Goals

This project aims to showcase the following functionalities:

* Creating 3 seperate environments (`test`, `dev`, `prod`) using Terraform and deploying application across these environments. 
* **Test Env**:Setting up a local development environment for testing the YelpCamp application (done on a GCP Compute Engine).
* **Dev Env**:Building and deploying the application in a Docker container using a Jenkins pipeline.
* **Prod Env**:Automating deployment of the application to a Google Kubernetes Engine (GKE) cluster through a Jenkins pipeline.
* Using automation as much as possible, leverage GCP's metadata feature to install all tools using startup scripts.

### Technologies Used
<p align="left">
  <a>
    <img src="https://skillicons.dev/icons?i=gcp,terraform,kubernetes,docker,jenkins,nodejs,git,bash&theme=dark"/>
  </a>
</p>

* Google Kubernetes Engine (GKE)
* Sonarqube
* Trivy

### Getting Started
This project requires the following pre-requisites:
* A Google Cloud Platform account
* Docker installed locally
* Basic understanding of Cloud Shell, Jenkins, and Kubernetes concepts

#### Setting Up the Environments

**Test Environment : Testing the YelpCamp application with npm**

1. 

**Dev Environment: Docker Deployment with Jenkins**
1. Configure Jenkins following the instructions in the `Jenkins` directory.
2. The `Jenkins` directory also includes a sample Jenkins pipeline that automates building and deploying the application in a Docker container.

**Prod Environment: GKE Deployment with Jenkins**
1. Set up a GKE cluster following the GCP documentation or the instructions in the `GKE` directory.
2. The `GKE` directory includes a sample Jenkins pipeline that automates building, containerizing, and deploying the application to your GKE cluster.

## Contributing
We welcome contributions to this project! Please see the `CONTRIBUTING.md` file for guidelines on how to contribute.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details. 
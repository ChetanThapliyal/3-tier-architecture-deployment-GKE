# YelpCamp (3 tier aarchitecture) with Docker and GKE

This project demonstrates deploying YelpCamp application (a full-stack website for campground reviews) across various environments using Cloud DevOps practices.

## Project Goals

This project aims to showcase the following functionalities:

* Creating 3 seperate environments (`test`, `dev`, `prod`)
* Setting up a local development environment for testing the YelpCamp application (done on a GCP VM).
* Building and deploying the application in a Docker container using a Jenkins pipeline.
* Automating deployment of the application to a Google Kubernetes Engine (GKE) cluster through a Jenkins pipeline.
* Using automation as much as possible, leverage GCP's metadata feature to install all tools using startup scripts.

## Technologies Used

<p align="left">
  <a>
    <img src="https://skillicons.dev/icons?i=gcp,kubernetes,docker,jenkins,git,github,bash&theme=dark" width="600" height="300"/>
    <img src="./argocd-original.svg" width="80" height="40">
  </a>
</p>

* Google Cloud Platform (GCP)
* Google Kubernetes Engine (GKE)
* Docker
* Jenkins
* Kubernetes
* 

## Getting Started

This project requires the following pre-requisites:

* A Google Cloud Platform account
* Docker installed locally
* Basic understanding of Cloud Shell, Jenkins, and Kubernetes concepts

**Setting Up the Local Environment**

1. Follow the instructions in the `local_env` directory to create a GCP VM and deploy the YelpCamp application locally.

**Docker Deployment with Jenkins**

1. Configure Jenkins following the instructions in the `jenkins` directory.
2. The `jenkins` directory also includes a sample Jenkins pipeline that automates building and deploying the application in a Docker container.

**GKE Deployment with Jenkins**

1. Set up a GKE cluster following the GCP documentation.
2. The `gke` directory includes a sample Jenkins pipeline that automates building, containerizing, and deploying the application to your GKE cluster.

## Contributing

We welcome contributions to this project! Please see the `CONTRIBUTING.md` file for guidelines on how to contribute.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

**Note:**

* Replace the bracketed sections with specific instructions for setting up each environment. 
* You can add additional sections to the README for further documentation,  like project structure or how to run tests (if applicable). 
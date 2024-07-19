# YelpCamp (3-tier architecture) Deployment with Docker and GKE

This project demonstrates deploying the YelpCamp application, a full-stack website for campground reviews, with a 3-tier architecture across various environments (`test`, `dev`, `prod`) using Cloud DevOps practices.

![Architecture](./Architecture/3-tier-deployment.drawio.png)

## Project Goals

This project aims to showcase the following functionalities:

* Creating three separate environments (`test`, `dev`, `prod`) using Terraform and deploying the application across these environments.
* **Test Environment**: Setting up a local development environment for testing the YelpCamp application (done on a GCP Compute Engine).
* **Dev Environment**: Building and deploying the application in a Docker container using a Jenkins pipeline.
* **Prod Environment**: Automating deployment of the application to a Google Kubernetes Engine (GKE) cluster through a Jenkins pipeline.
* Leveraging automation wherever possible, including the use of GCP's metadata feature and startup scripts to install all necessary tools.

### Technologies Used

<p align="left">
  <a>
    <img src="https://skillicons.dev/icons?i=gcp,terraform,kubernetes,docker,jenkins,nodejs,git,bash&theme=dark"/>
  </a>
</p>

* Google Kubernetes Engine (GKE)
* Terraform
* Docker
* Jenkins
* Node.js
* Git
* Bash
* SonarQube
* Trivy

## Getting Started

This project requires the following prerequisites:
* A Google Cloud Platform account
* Docker installed locally
* Basic understanding of Cloud Shell, Jenkins, and Kubernetes concepts

#### Cloning the Repository

To clone the repository and set it up locally, use the following commands:

```bash
git clone https://github.com/ChetanThapliyal/3-tier-architecture-deployment-GKE.git
cd 3-tier-architecture-deployment-GKE
```

#### Setting up the Environments

Create a `terraform.tfvars` file for each environment (`test`, `dev`, `prod`) with the necessary variables. Below is a generic structure of what your `terraform.tfvars` file might look like:

```hcl
# terraform.tfvars

project = "your-gcp-project-id"
region  = "your-gcp-region"
credentials = "path-to-your-service-account-file.json"
```

**Global VPC**
1. Navigate to the `Infra` directory:
   ```bash
    cd Infra
    ```
2. Create and configure the `terraform.tfvars` file for the VPC.
3. Initialize Terraform and apply the configuration:
    ```bash
    terraform init
    terraform apply
    ```

 **Test Environment: Testing the YelpCamp application with npm**

1. Navigate to the `test` environment directory:
    ```bash
    cd Infra/environments/test
    ```
2. Create and configure the `terraform.tfvars` file for the test environment.
3. Initialize Terraform and apply the configuration:
    ```bash
    terraform init
    terraform apply
    ```

**Dev Environment: Docker Deployment with Jenkins**

1. Navigate to the `dev` environment directory:
    ```bash
    cd Infra/environments/dev
    ```
2. Create and configure the `terraform.tfvars` file for the dev environment.
3. Initialize Terraform and apply the configuration:
    ```bash
    terraform init
    terraform apply
    ```
4. Configure Jenkins following the instructions in the [Jenkins](https://github.com/ChetanThapliyal/3-tier-architecture-deployment-GKE/tree/main/configs/Jenkins) directory.

**Prod Environment: GKE Deployment with Jenkins**

1. Navigate to the `prod` environment directory:
    ```bash
    cd Infra/environments/prod
    ```
2. Create and configure the `terraform.tfvars` file for the prod environment.
3. Initialize Terraform and apply the configuration:
    ```bash
    terraform init
    terraform apply
    ```
4. Set up a GKE cluster following the GCP documentation or the instructions in the [GKE](https://github.com/ChetanThapliyal/3-tier-architecture-deployment-GKE/tree/main/configs/GKE) directory.
5. The `root` directory includes Jenkins pipelines for both 'dev' and 'prod' environments that automate building, containerizing, and deploying the application to your GKE cluster.

### Future Updates and Enhancements
To keep the YelpCamp project aligned with industry best practices and to ensure its security and scalability, the following updates and enhancements are planned:

1. **Binary Authorization for GKE**:
   - Implementing Binary Authorization to ensure that only trusted container images are deployed to the GKE cluster.
   - Enforcing policies to require image signatures and validating them against pre-approved trusted sources.

2. **Federated Identity for GKE**:
   - Integrating federated identity solutions to manage user access and authentication more effectively.
   - Using Identity-Aware Proxy (IAP) to provide secure access to the application without a VPN, leveraging OAuth for authentication.

3. **Service Mesh Implementation**:
   - Introducing Istio or Linkerd to manage microservices traffic, increase security, and improve observability.
   - Enabling mTLS (Mutual TLS) for secure service-to-service communication within the cluster.

4. **Enhanced Monitoring and Logging**:
   - Utilizing Prometheus and Grafana for better monitoring of the application and infrastructure.
   - Integrating Google Cloud Logging and Google Cloud Monitoring for centralized log management and alerting.

5. **Security Scanning and Compliance**:
   - Integrating Trivy and Clair for continuous security scanning of container images.
   - Ensuring compliance with industry standards and regulations by conducting regular security audits.

6. **Automated Scaling and Load Balancing**:
   - Configuring Horizontal Pod Autoscaler (HPA) and Cluster Autoscaler for dynamic scaling based on traffic and resource usage.
   - Implementing Google Cloud Load Balancing to distribute traffic effectively and ensure high availability.

7. **CI/CD Pipeline Enhancements**:
   - Refining the Jenkins pipeline to include automated rollback strategies and blue-green deployments.
   - Incorporating Canary deployments to test new features with a subset of users before full rollout.

8. **Infrastructure as Code (IaC) Improvements**:
   - Modularizing Terraform configurations further to promote reusability and maintainability.
   - Implementing Terratest for automated testing of Terraform configurations to ensure infrastructure reliability.

By implementing these enhancements, the YelpCamp project will not only adhere to best practices but also provide a robust, secure, and scalable architecture for its users.

## Contributing
We welcome contributions to this project! Please see the `CONTRIBUTING.md` file for guidelines on how to contribute.

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

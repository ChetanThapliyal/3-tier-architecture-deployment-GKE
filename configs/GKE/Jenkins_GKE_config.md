## Prerequisites
* Minimum Jenkins version: 2.164.2
* Jenkins plugin dependencies:
  * google-oauth-plugin: 0.7 (pre-installation required)
  * workflow-step-api: 2.19
  * pipeline-model-definition: 1.3.8 (pre-installation required for Pipeline DSL support)
  * git: 3.9.3
  * junit: 1.3
  * structs: 1.17
  * credentials: 2.1.16

## Setup

### Setup the necessary environment variables
```bash
export PROJECT=$(gcloud info --format='value(config.project)')
export CLUSTER=<YOUR_CLUSTER_NAME>
export ZONE=<YOUR_PROJECTS_ZONE>
export SA=<YOUR_GCP_SA_NAME>
export SA_EMAIL=${SA}@${PROJECT}.iam.gserviceaccount.com
```

### Enable Required GCP APIs

```bash
gcloud services enable compute.googleapis.com \
container.googleapis.com \
servicemanagement.googleapis.com \
cloudresourcemanager.googleapis.com \
    --project $PROJECT
```

### Configure target GKE cluster

1. If necessary, create your GKE cluster: (# In this project we are creating clluster using terraform so skip this step)
    ```bash
    gcloud container clusters create $CLUSTER --zone $ZONE
    ```

1. Retrieve the KubeConfig for your cluster:
    ```bash
    gcloud container clusters get-credentials $CLUSTER --zone $ZONE
    ```

1. If necessary, grant your GCP login account cluster-admin permissions necessary for creating cluster role bindings:
   ```bash
   kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin \
        --user=$(gcloud config get-value account)
   ```

### Manually Configure GCP Service Account Permissions

Manual procedures for configuring the permissions necessary for GCP service account to deploy to your GKE cluster. 

Automation is also provided for executing these procedures using [Terraform](https://www.terraform.io/docs/index.html) and [Helm](https://helm.sh) in the [Automated Permissions Configuration](#automated-permissions-configuration) section.

#### GCP IAM Permissions

1. Create a service account using the Google Cloud SDK:
    ```bash
    gcloud iam service-accounts create $SA
    ```
1. Create custom GCP IAM Role with minimal permissions using the custom role defined within [rbac/IAMrole.yaml](rbac/IAMrole.yaml):
    ```bash
    gcloud iam roles create gke_deployer --project $PROJECT --file \
    rbac/IAMrole.yaml
	```
1. Grant the IAM role to your GCP service account:
    ```bash
    gcloud projects add-iam-policy-binding $PROJECT \
    --member serviceAccount:$SA_EMAIL \
    --role projects/$PROJECT/roles/gke_deployer
    ```
1. Download a JSON Service Account key for your newly created service account. Take note of where the file was created, you will upload it to Jenkins in a subsequent step:
    ```bash
    gcloud iam service-accounts keys create ~/jenkins-gke-key.json --iam-account $SA_EMAIL
    ```
    * If using cloud shell, click the 3 vertical dots and **Download file**, then enter "jenkins-gke-key.json".

1. In Jenkins on the left side of the screen, click on **Credentials**, then **System**.
2. Click **Global credentials** then **Add credentials** on the left.
3. In the **Kind** dropdown, select `Google Service Account from private key`.
4. Enter your project name, then select your JSON key that was created in the preceding steps.
5. Click **OK**.

#### GKE Cluster RBAC Permissions
Grant your GCP service account a restricted set of RBAC permissions allowing it to deploy to your GKE cluster.

1. Create the custom robot-deployer cluster role defined within [rbac/robot-deployer.yaml](rbac/robot-deployer.yaml):
    ```bash
    kubectl create -f rbac/robot-deployer.yaml
    ```

1. Grant your GCP service account the robot-deployer role binding using [rbac/robot-deployer-bindings.yaml](rbac/robot-deployer-bindings.yaml):
    ```bash
    envsubst < rbac/robot-deployer-bindings.yaml | kubectl create -f -
    ```

### Automated Permissions Configuration

This section demonstrates using provided automation for configuring the necessary GCP service account permissions for deploying to your GKE cluster.

#### GCP IAM Permissions

1. Navigate to the [rbac](rbac) directory:
    ```bash
    pushd rbac/
    ```

2. The [gcp-sa-setup.tf](rbac/gcp-sa-setup.tf) Terraform plan will create a custom GCP IAM role with
restricted permissions, create a GCP service account, and grant said service account the custom role.
(NOTE: This only needs to be done once).
    ```bash
    export TF_VAR_PROJECT=${PROJECT}
    export TF_VAR_REGION=${REGION}
    export TF_VAR_SA_NAME=${SA}
    terraform init
    terraform plan -out /tmp/tf.plan
    terraform apply /tmp/tf.plan
    rm /tmp/tf.plan
    ```
#### GKE Cluster RBAC Permissions

1. Navigate to the [helm](helm) directory
   ```bash
   popd
   pushd helm/
   ```

2. Execute the helm chart provided within this directory to create the [robot-deployer](../rbac/robot-deployer.yaml)
cluster role, and grant your GCP service account the robot-deployer role binding. This will need to be executed
on each cluster being deployed to by the plugin. If necessary follow the [instructions](https://helm.sh/docs/using_helm/#initialize-helm-and-install-tiller)
provided by the helm project for configuring helm/tiller on your GKE cluster.
    ```bash
    export TARGET_NAMESPACE=<YOUR_TARGET_NAMESPACE>
    envsubst < gke-robot-deployer/values.yaml | helm install ./gke-robot-deployer --name gke-robot-deployer -f -
    ```

##### References:
* [Google Container Engine RBAC docs](
  https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control)
* [Configuring RBAC for GKE deployment](
  https://codeascraft.com/2018/06/05/deploying-to-google-kubernetes-engine/)

## Usage

### Google Kubernetes Engine Build Step Configuration

Each GKE Build Step configuration can point to a different GKE cluster. Follow the steps below to create one.

##### GKE Build Step Parameters

The GKE Build Step has the following parameters:

1. `credentialsId(string)`: The ID of the credentials that you uploaded earlier.
1. `projectId(string)`: The Project ID housing the GKE cluster to be published to.
1. `zone(string)`: [**Deprecated**] The Zone housing the GKE cluster to be published to.
1. `location(string)`: The Zone or Region housing the GKE cluster to be published to.
1. `clusterName(string)`: The name of the Cluster to be published to.
1. `manifestPattern(string)`: The file pattern of the Kubernetes manifest to be deployed.
1. `verifyDeployments(boolean)`: [Optional] Whether the plugin will verify deployments.

#### Jenkins Web UI

1. On the Jenkins home page, select the project to be published to GKE.
2. Click **Configure** from the left nav-bar.
3. At the bottom of the page there will be a button labeled **Add build step**, click the button then select `Deploy to Google Kubernetes Engine`.
4. In the **Service Account Credentials** dropdown, select the credentials that you uploaded earlier. This should autopopulate **Project ID** and **Cluster**, if not:
  * Select the Project ID housing the GKE cluster to be published to.
  * Select the Cluster to be published to.
5. Enter the file path of the Kubernetes [manifest](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) within your project to be used for deployment.

#### Jenkins Declarative Pipeline

1. Create a file named "Jenkinsfile" in the root of your project.
1. Within your Jenkinsfile add a step which invokes the GKE plugin's build step class:
"KubernetesEngineBuilder". See the example code below:

```groovy
pipeline {
    agent any
    environment {
        PROJECT_ID = '<YOUR_PROJECT_ID>'
        CLUSTER_NAME = '<YOUR_CLUSTER_NAME>'
        LOCATION = '<YOUR_CLUSTER_LOCATION>'
        CREDENTIALS_ID = '<YOUR_CREDENTIAS_ID>'
    }
    stages {
        stage('Deploy to GKE') {
            steps{
                step([
                $class: 'KubernetesEngineBuilder',
                projectId: env.PROJECT_ID,
                clusterName: env.CLUSTER_NAME,
                location: env.LOCATION,
                manifestPattern: 'manifest.yaml',
                credentialsId: env.CREDENTIALS_ID,
                verifyDeployments: true])
            }
        }
    }
}
```
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

### Configure target GKE cluster

1. Retrieve the KubeConfig for your cluster:
    ```bash
    gcloud container clusters get-credentials $CLUSTER --zone $ZONE
    ```

2. If necessary, grant your GCP login account cluster-admin permissions necessary for creating cluster role bindings:
   ```bash
   kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin \
        --user=$(gcloud config get-value account)
   ```

### Configure GCP Service Account
- We have created Service Account and GKE cluster using Jenkins.

1. Download a JSON Service Account key for your newly created service account. Take note of where the file was created, you will upload it to Jenkins in a subsequent step:
    ```bash
    gcloud iam service-accounts keys create ~/jenkins-gke-key.json --iam-account $SA_EMAIL
    ```
    * If using cloud shell, click the 3 vertical dots and **Download file**, then enter "jenkins-gke-key.json".

2. In Jenkins on the left side of the screen, click on **Credentials**, then **System**.
3. Click **Global credentials** then **Add credentials** on the left.
4. In the **Kind** dropdown, select `Google Service Account from private key`.
5. Enter your project name, then select your JSON key that was created in the preceding steps.
6. Click **OK**.

#### GKE Cluster RBAC Permissions
Grant your GCP service account a restricted set of RBAC permissions allowing it to deploy to your GKE cluster.

1. Create the custom robot-deployer cluster role defined within [rbac/robot-deployer.yaml](rbac/robot-deployer.yaml):
    ```bash
    kubectl create -f rbac/robot-deployer.yaml
    ```

2. Grant your GCP service account the robot-deployer role binding using [rbac/robot-deployer-bindings.yaml](rbac/robot-deployer-bindings.yaml):
    ```bash
    envsubst < rbac/robot-deployer-bindings.yaml | kubectl create -f -
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
2. `projectId(string)`: The Project ID housing the GKE cluster to be published to.
3. `zone(string)`: [**Deprecated**] The Zone housing the GKE cluster to be published to.
4. `location(string)`: The Zone or Region housing the GKE cluster to be published to.
5. `clusterName(string)`: The name of the Cluster to be published to.
6. `manifestPattern(string)`: The file pattern of the Kubernetes manifest to be deployed.
7. `verifyDeployments(boolean)`: [Optional] Whether the plugin will verify deployments.

#### Jenkins Web UI

1. On the Jenkins home page, select the project to be published to GKE.
2. Click **Configure** from the left nav-bar.
3. At the bottom of the page there will be a button labeled **Add build step**, click the button then select `Deploy to Google Kubernetes Engine`.
4. In the **Service Account Credentials** dropdown, select the credentials that you uploaded earlier. This should autopopulate **Project ID** and **Cluster**, if not:
  * Select the Project ID housing the GKE cluster to be published to.
  * Select the Cluster to be published to.
5. Enter the file path of the Kubernetes [manifest](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) within your project to be used for deployment.

### Jenkins Global Environment Variables
- Save following variables in Jenins Global variables:
  * PROJECT_ID
  * CLUSTER_NAME
  * LOCATION
  * CREDENTIALS_ID
- `Manage Jenkins` -> `Configure System` -> `Global properties` -> `Environment Variables` -> `Add`


#### Jenkins Declarative Pipeline

1. Create a file named "Jenkinsfile" in the root of your project.
2. Within your Jenkinsfile add a step which invokes the GKE plugin's build step class:
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
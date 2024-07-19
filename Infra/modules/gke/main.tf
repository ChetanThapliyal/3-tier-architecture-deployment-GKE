# Creates Service Account for GKE
resource "google_service_account" "gke_sa" {
    account_id   = "gke-service-account"
    display_name = "GKE Service Account"
    project      = var.gcp_project_id
}

# Create Custom IAM Role
resource "google_project_iam_custom_role" "gke_deployer_role" {
    role_id     = "gke_deployer"
    title       = "Jenkins GKE Viewer and Developer"
    description = "Minimal IAM role for the Jenkins GKE plugin with additional permissions for deploying and managing Kubernetes resources."
    project     = var.gcp_project_id

    permissions = [
        "container.apiServices.get",
        "container.apiServices.list",
        "container.clusters.get",
        "container.clusters.getCredentials",
        "container.clusters.list",
        "container.deployments.get",
        "container.deployments.list",
        "container.deployments.update",
        "container.deployments.create",
        "container.deployments.delete",
        "container.services.get",
        "container.services.list",
        "container.services.update",
        "container.services.create",
        "container.services.delete",
        "resourcemanager.projects.get",
        "container.developer"
    ]
}

# Grant IAM roles to the Service Account
resource "google_project_iam_binding" "gke_sa_roles" {
    project = var.gcp_project_id
    role    = [
        "roles/container.nodeServiceAccount",
        "roles/container.admin",
        "roles/compute.viewer",
        "roles/storage.admin",
        "roles/iam.serviceAccountUser",
        "projects/${var.gcp_project_id}/roles/gke_deployer"
    ]
    members = [
        "serviceAccount:${google_service_account.gke_sa.email}"
    ]
}

resource "google_container_cluster" "primary" {
    name                     = var.cluster_name
    location                 = var.zone
    project                  = var.gcp_project_id
    remove_default_node_pool = true
    initial_node_count       = 1
    network                  = var.network_name
    resource_labels = {
        environment = var.environment
        project     = var.gcp_project_id
    }
}

# Creates Node Pool for GKE
resource "google_container_node_pool" "primary_preemptible_nodes" {
    depends_on = [google_container_cluster.primary]
    name       = var.node_pool_name
    location   = var.zone
    cluster    = google_container_cluster.primary.name
    node_count = var.node_count
    project    = var.gcp_project_id

    node_config {
        preemptible  = true
        machine_type = var.machine_type
        disk_size_gb = 50  # Added disk size parameter
        service_account = google_service_account.gke_sa.email
        oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
        ]
        labels = {
        environment = var.environment
        }
        tags = ["gke-node", "my-cluster-node"]
    }

    autoscaling {
        min_node_count = 1
        max_node_count = 4
    }
}

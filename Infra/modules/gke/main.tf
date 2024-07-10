# Creates Service Account for GKE
resource "google_service_account" "gke_sa" {
    account_id   = "gke-service-account"
    display_name = "GKE Service Account"
    project      = var.gcp_project_id
}

# Creates IAM Member for GKE Service Account
resource "google_project_iam_member" "gke_sa_iam" {
    project = var.gcp_project_id
    role    = "roles/container.nodeServiceAccount"
    member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

resource "google_project_iam_member" "gke_sa_container_admin" {
    project = var.gcp_project_id
    role    = "roles/container.admin"
    member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

resource "google_project_iam_member" "gke_sa_compute_viewer" {
    project = var.gcp_project_id
    role    = "roles/compute.viewer"
    member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

resource "google_project_iam_member" "gke_sa_storage_admin" {
    project = var.gcp_project_id
    role    = "roles/storage.admin"
    member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

resource "google_project_iam_member" "gke_sa_iam_service_account_user" {
    project = var.gcp_project_id
    role    = "roles/iam.serviceAccountUser"
    member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

resource "google_container_cluster" "primary" {
    name     = var.cluster_name
    location = var.region

    remove_default_node_pool = true
    initial_node_count       = 1
    network       = var.network_name

    resource_labels = {
        environment = var.environment
        project     = var.gcp_project_id
    }
}

# Creates Node Pool for GKE
resource "google_container_node_pool" "primary_preemptible_nodes" {
    depends_on = [ google_container_cluster.primary ]
    name       = var.node_pool_name
    location   = var.region
    cluster    = google_container_cluster.primary.name
    node_count = var.node_count
    project    = var.gcp_project_id

    node_config {
        preemptible  = true
        machine_type = var.machine_type
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
        max_node_count = 5
    }
}

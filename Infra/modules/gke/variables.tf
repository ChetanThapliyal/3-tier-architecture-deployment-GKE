variable "cluster_name" {
    description = "The name of the GKE cluster"
    type        = string
    default     = "my-gke-cluster"
}

variable "node_pool_name" {
    description = "The name of the node pool"
    type        = string
    default     = "my-node-pool"
}

variable "node_count" {
    description = "The initial node count"
    type        = number
    default     = 3
}

variable "gcp_project_id" {
    description = "GCP Project ID"
    type        = string
}

variable "region" {
    description = "The region to deploy resources in"
    type        = string
    default     = "us-central1"
}

variable "machine_type" {
    description = "The machine type for the nodes"
    type        = string
    default     = "e2-medium"
}

variable "environment" {
    description = "The environment for resource labels"
    type        = string
    default     = "test"
}

variable "network_name" {
    description = "Name of the network for the VM instance"
    type        = string
}
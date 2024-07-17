variable "vm_configs" {
    description = "List of VM configurations"
    type = list(object({
        vm_name                   = string
        machine_type              = string
        zone                      = string
        labels                    = map(string)
        metadata                  = map(string)
        tags                      = list(string)
        network_name              = string
        device_name               = string
        image                     = string
        disk_size                 = number
    }))
}

variable "gcp_project_id" {
    description = "GCP Project ID"
    type        = string
}

variable "gcp_service_account_email" {
    sensitive = true
    description = "value of service account email"
}

variable "zone" {
    description = "The region to deploy resources in"
    type        = string
    default     = "asia-south1-a"
}

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


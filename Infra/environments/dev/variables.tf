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
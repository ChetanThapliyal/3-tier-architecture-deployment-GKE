variable "gcp_project_id" {
    sensitive = true
    description = "value of project id"
}

variable "vm_name" {
    description = "Name of the VM instance"
    type        = string
}

variable "machine_type" {
    description = "Type of machine to create"
    type        = string
}

variable "zone" {
    description = "Zone where the VM instance will be created"
    type        = string
}

variable "labels" {
    description = "Labels to be assigned to the VM instance"
    type        = map(string)
}

variable "metadata" {
    description = "Metadata for the VM instance"
    type        = map(string)
}

variable "network_name" {
    description = "Name of the network for the VM instance"
    type        = string
}

variable "device_name" {
    description = "Device name for the boot disk"
    type        = string
}

variable "image" {
    description = "Image for the boot disk"
    type        = string
}

variable "disk_size" {
    description = "Disk size in GB"
    type        = number
}

variable "gcp_service_account_email" {
    description = "Service account email for the VM instance"
    type        = string
}

variable "tags" {
    description = "Tags for the VM instance"
    type        = list(string)
}
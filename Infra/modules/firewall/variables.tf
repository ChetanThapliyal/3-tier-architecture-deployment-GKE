# modules/firewall/variables.tf
variable "firewall_custom_name" {
    description = "Name of the custom firewall rule"
    type        = string
}

variable "firewall_icmp_name" {
    description = "Name of the ICMP firewall rule"
    type        = string
}

variable "firewall_ssh_name" {
    description = "Name of the SSH firewall rule"
    type        = string
}

variable "gcp_project_id" {
    description = "GCP Project ID"
    type        = string
}

variable "network_name" {
    description = "Name of the network"
    type        = string
}

variable "custom_source_ranges" {
    description = "Source ranges for the custom firewall rule"
    type        = list(string)
}

variable "custom_ports" {
    description = "Ports for the custom firewall rule"
    type        = list(string)
}

variable "icmp_source_ranges" {
    description = "Source ranges for the ICMP firewall rule"
    type        = list(string)
}

variable "ssh_source_ranges" {
    description = "Source ranges for the SSH firewall rule"
    type        = list(string)
}

variable "ssh_ports" {
    description = "Ports for the SSH firewall rule"
    type        = list(string)
}


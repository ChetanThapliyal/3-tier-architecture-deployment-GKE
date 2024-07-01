variable "gcp_svc_key" {
  sensitive = true
  description = "value of service key"
}

variable "gcp_project_id" {
  sensitive = true
  description = "value of project id"
}

variable "gcp_region" {
  description = "value of region"
  default = "asia-south1"
  sensitive = true
}

variable "network_name" {
  description = "value of network name"
}

variable "gcp_zone" {
  description = "value of zone"
  default = "asia-south1-a"
  sensitive = true
}

variable "gcp_service_account_email" {
  sensitive = true
  description = "value of service account email"
}

variable "gcp_network_interface_subnetworks" {
  description = "value of network interface subnetworks"
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

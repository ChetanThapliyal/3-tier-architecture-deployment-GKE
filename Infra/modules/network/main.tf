resource "google_compute_network" "custom_vpc" {
    auto_create_subnetworks = true
    description             = "VPC for secure CICD pipeline."
    mtu                     = 1460
    name                    = var.network_name
    project                 = var.gcp_project_id
    routing_mode            = "REGIONAL"
}
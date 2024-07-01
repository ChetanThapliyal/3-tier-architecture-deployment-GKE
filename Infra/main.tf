# Define global resources if any, otherwise use particular environments created (local, dev, prod)

module "network" {
    source = "./modules/network"
    gcp_project_id = var.gcp_project_id
    network_name   = var.network_name
}

# root main.tf
module "firewall" {
    source = "./modules/firewall"
    depends_on = [module.network]

    firewall_custom_name = var.firewall_custom_name
    firewall_icmp_name   = var.firewall_icmp_name
    firewall_ssh_name    = var.firewall_ssh_name
    gcp_project_id       = var.gcp_project_id
    network_name         = var.network_name
    custom_source_ranges = var.custom_source_ranges
    custom_ports         = var.custom_ports
    icmp_source_ranges   = var.icmp_source_ranges
    ssh_source_ranges    = var.ssh_source_ranges
    ssh_ports            = var.ssh_ports
}
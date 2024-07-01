resource "google_compute_firewall" "allow_custom" {
    name          = var.firewall_custom_name
    project       = var.gcp_project_id
    network       = var.network_name
    description   = "Allows connection from any source to any instance on the network using custom protocols."
    direction     = "INGRESS"
    priority      = 65534
    source_ranges = var.custom_source_ranges
    allow {
        protocol = "tcp"
        ports    = var.custom_ports
    }
}

resource "google_compute_firewall" "allow_icmp" {
    name          = var.firewall_icmp_name
    project       = var.gcp_project_id
    network       = var.network_name
    direction     = "INGRESS"
    priority      = 65534
    source_ranges = var.icmp_source_ranges
    description   = "Allows ICMP connections from any source to any instance on the network."
    allow {
        protocol = "icmp"
        }
}

resource "google_compute_firewall" "allow_ssh" {
    name          = var.firewall_ssh_name
    project       = var.gcp_project_id
    network       = var.network_name
    direction     = "INGRESS"
    priority      = 65534
    source_ranges = var.ssh_source_ranges
    description   = "Allows TCP connections from any source to any instance on the network using port 22."
    allow {
    protocol = "tcp"
    ports    = var.ssh_ports
    }
}

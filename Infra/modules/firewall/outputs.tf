# modules/firewall/outputs.tf
output "firewall_custom_name" {
    value = google_compute_firewall.allow_custom.name
}

output "firewall_icmp_name" {
    value = google_compute_firewall.allow_icmp.name
}

output "firewall_ssh_name" {
    value = google_compute_firewall.allow_ssh.name
}
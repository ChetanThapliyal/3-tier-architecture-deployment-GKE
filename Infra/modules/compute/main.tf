resource "google_compute_instance" "vm_instance" {
    name           = var.vm_name
    project        = var.gcp_project_id
    machine_type   = var.machine_type
    zone           = var.zone
    labels         = var.labels
    metadata       = var.metadata #startup script
    tags = var.tags
    
    network_interface {
        network       = var.network_name
        access_config {
        network_tier = "STANDARD"
        }
        queue_count = 0
        stack_type  = "IPV4_ONLY"
    }

    boot_disk {
        auto_delete = true
        device_name = var.device_name
        initialize_params {
            image = var.image
            size  = var.disk_size
            type  = "pd-balanced"
        }
        mode = "READ_WRITE"
    }

    can_ip_forward      = false
    deletion_protection = false
    enable_display      = false

    scheduling {
        automatic_restart   = true
        on_host_maintenance = "MIGRATE"
        preemptible         = false
        provisioning_model  = "STANDARD"
    }

    service_account {
        email  = var.gcp_service_account_email
        scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    }

    shielded_instance_config {
        enable_integrity_monitoring = true
        enable_secure_boot          = false
        enable_vtpm                 = true
    }
}

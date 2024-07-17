locals {
    vm_configs = var.vm_configs
}

data "terraform_remote_state" "global" {
    backend = "local"
    config = {
        path = "../../terraform.tfstate"
    }
}

module "compute" {
    for_each = { for idx, vm_config in local.vm_configs : idx => vm_config }

    source                     = "../../modules/compute"
    vm_name                    = each.value.vm_name
    machine_type               = each.value.machine_type
    zone                       = each.value.zone
    labels                     = each.value.labels
    metadata                   = {startup-script = file("${path.module}/../../scripts/${each.value.metadata.startup-script}")}
    tags                       = each.value.tags
    network_name               = data.terraform_remote_state.global.outputs.network_name
    device_name                = each.value.device_name
    image                      = each.value.image
    disk_size                  = each.value.disk_size
    gcp_service_account_email  = var.gcp_service_account_email
    gcp_project_id             = var.gcp_project_id
}

module "gke_cluster" {
    source = "../../modules/gke"
    gcp_project_id = var.gcp_project_id
    network_name   = data.terraform_remote_state.global.outputs.network_name
    cluster_name   = var.cluster_name
    node_pool_name = var.node_pool_name
    node_count     = var.node_count
    machine_type   = var.machine_type
    environment    = var.environment
}
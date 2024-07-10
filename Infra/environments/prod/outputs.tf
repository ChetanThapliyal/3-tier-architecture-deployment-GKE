output "cluster_name" {
  value = module.gke_cluster.cluster_name
}

output "node_pool_name" {
  value = module.gke_cluster.node_pool_name
}
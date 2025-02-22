module "configuration" {
  source = "../../common/configuration"

  configuration = var.configuration
  base_key      = var.configuration_base_key
}

locals {
  # current workspace config
  cfg = module.configuration.merged[terraform.workspace]

  name_prefix = local.cfg["name_prefix"]

  base_domain = local.cfg["base_domain"]

  project_id = local.cfg["project_id"]

  region = local.cfg["region"]

  cluster_node_locations_lookup = lookup(local.cfg, "cluster_node_locations", "")
  cluster_node_locations        = split(",", local.cluster_node_locations_lookup)

  cluster_min_master_version = local.cfg["cluster_min_master_version"]

  cluster_daily_maintenance_window_start_time = lookup(
    local.cfg,
    "cluster_daily_maintenance_window_start_time",
    "03:00",
  )

  remove_default_node_pool = lookup(local.cfg, "remove_default_node_pool", true)

  cluster_initial_node_count = lookup(local.cfg, "cluster_initial_node_count", 1)

  cluster_min_node_count = lookup(local.cfg, "cluster_min_node_count", 1)
  cluster_max_node_count = lookup(local.cfg, "cluster_max_node_count", 1)

  cluster_extra_oauth_scopes_lookup = lookup(local.cfg, "cluster_extra_oauth_scopes", "")
  cluster_extra_oauth_scopes        = split(",", local.cluster_extra_oauth_scopes_lookup)

  cluster_disk_size_gb = lookup(local.cfg, "cluster_disk_size_gb", 100)

  cluster_disk_type = lookup(local.cfg, "cluster_disk_type", "pd-standard")

  cluster_image_type = lookup(local.cfg, "cluster_image_type", "COS")

  cluster_machine_type = lookup(local.cfg, "cluster_machine_type", "")

  cluster_preemptible = lookup(local.cfg, "cluster_preemptible", false)

  cluster_auto_repair = lookup(local.cfg, "cluster_auto_repair", true)

  cluster_auto_upgrade = lookup(local.cfg, "cluster_auto_upgrade", true)

  disable_default_ingress = lookup(local.cfg, "disable_default_ingress", false)

  enable_private_nodes = lookup(local.cfg, "enable_private_nodes", true)
  master_cidr_block    = lookup(local.cfg, "master_cidr_block", "172.16.0.32/28")

  # by default include cloud_nat when private nodes are enabled
  enable_cloud_nat                       = lookup(local.cfg, "enable_cloud_nat", local.enable_private_nodes)
  cloud_nat_endpoint_independent_mapping = lookup(local.cfg, "cloud_nat_enable_endpoint_independent_mapping", null)
  cloud_nat_min_ports_per_vm             = lookup(local.cfg, "cloud_nat_min_ports_per_vm", null)
  cloud_nat_ip_count                     = lookup(local.cfg, "cloud_nat_ip_count", 0)

  disable_workload_identity             = lookup(local.cfg, "disable_workload_identity", false)
  default_node_workload_metadata_config = tobool(local.disable_workload_identity) == false ? "GKE_METADATA" : "MODE_UNSPECIFIED"
  node_workload_metadata_config         = lookup(local.cfg, "node_workload_metadata_config", local.default_node_workload_metadata_config)

  master_authorized_networks_config_cidr_blocks_lookup = lookup(local.cfg, "master_authorized_networks_config_cidr_blocks", null)
  master_authorized_networks_config_cidr_blocks        = local.master_authorized_networks_config_cidr_blocks_lookup == null ? null : split(",", local.master_authorized_networks_config_cidr_blocks_lookup)

  enable_tpu = lookup(local.cfg, "enable_tpu", false)
}

provider "kubernetes" {
  load_config_file       = false
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

data "google_compute_zones" "available" {}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  version                    = "13.1.0"
  project_id                 = var.project
  name                       = var.gke_name
  region                     = var.region
  zones                      = slice(data.google_compute_zones.available.names, 1, 3)
  network                    = var.gke_network
  subnetwork                 = var.gke_subnetwork
  ip_range_pods              = format("gke-%s-%s-pods", var.region, var.gke_name)
  ip_range_services          = format("gke-%s-%s-services", var.region, var.gke_name)
  http_load_balancing        = false
  horizontal_pod_autoscaling = false
  network_policy             = false
  create_service_account     = true

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "e2-medium"
      node_locations     = join(",", slice(data.google_compute_zones.available.names, 1, 3))
      min_count          = 1
      max_count          = 100
      local_ssd_count    = 0
      disk_size_gb       = 40
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 80
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}
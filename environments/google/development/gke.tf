resource "google_service_account" "kubernetes" {
  account_id   = "k8s-service-account"
  display_name = "Kubernetes Service Account"
}

resource "google_container_cluster" "primary" {
  name     = "shortlist-dev"
  location = "europe-west1-b"

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.primary.id
  subnetwork = google_compute_subnetwork.primary_europe_west_1.id

  deletion_protection = false

  workload_identity_config {
    workload_pool = "${data.google_project.project.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "primary_general_purpose" {
  name       = "shortlist-general-purpose"
  location   = "europe-west1-b"
  cluster    = google_container_cluster.primary.name
  node_count = 2 

  node_config {
    machine_type = "e2-small"

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
      ]
  }

  lifecycle {
    # Trying to reconcile kubelet_config in state file with actual state leads to bad API request
    ignore_changes = [node_config[0].kubelet_config, node_config[0].resource_labels]
  }
}

resource "google_container_node_pool" "primary_gpu" {
  name       = "shortlist-gpu"
  location   = "europe-west1-b"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    machine_type = "g2-standard-4"
    spot = true

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
      ]
  }

  lifecycle {
    # Trying to reconcile kubelet_config in state file with actual state leads to bad API request
    ignore_changes = [node_config[0].kubelet_config, node_config[0].resource_labels]
  }
}

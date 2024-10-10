resource "google_service_account" "kubernetes" {
  account_id   = "k8s-service-account"
  display_name = "Kubernetes Service Account"
}

resource "google_container_cluster" "primary" {
  name     = "shortlist-dev"
  location = "europe-west1"

  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false
}

resource "google_container_node_pool" "primary_general_purpose" {
  name       = "shortlist-general-purpose"
  location   = "europe-west1"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    machine_type = "e2-small"

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

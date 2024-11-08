resource "google_compute_network" "primary" {
  name                    = "shortlist-dev-primary-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "primary_europe_west_1" {
  name          = "primary-europe-west1"
  ip_cidr_range = "10.128.0.0/20"
  region        = "europe-west1"
  network       = google_compute_network.primary.id
}

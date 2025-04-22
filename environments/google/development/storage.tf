locals {
  assessor_cache_bucket_name = "dev-shortlist-assesor-cache"
}

resource "google_storage_bucket" "assessor_cache" {
  name          = local.assessor_cache_bucket_name
  location      = "EU"
  force_destroy = true

  public_access_prevention = "enforced"
}

resource "google_storage_bucket_iam_binding" "binding" {
  bucket = local.assessor_cache_bucket_name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.kubernetes.email}"
  ]
}

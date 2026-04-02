data "google_storage_bucket" "assessor_cache" {
  name      = var.assessor_cache_bucket_name
}

resource "google_storage_bucket_iam_binding" "binding" {
  bucket = var.assessor_cache_bucket_name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.kubernetes.email}"
  ]
}

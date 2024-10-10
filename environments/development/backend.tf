terraform {
  backend "gcs" {
    bucket = "shortlist-dev-terraform-backend"
    prefix = "development"
  }
}


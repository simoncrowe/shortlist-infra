variable "domain" {
  description = "The root domain name used for email, without subdomains"
  type        = string
}

variable "gke_oidc_issuer_hostname" {
  description = "The GKE cluster's OIDC issuer hostname. (The GKE cluster that sends email)"
  type        = string
}

variable "gke_service_account_id" {
  description = "The GKE cluster's service account ID. (The GKE cluster that sends email)"
  type        = string
}

variable "domain" {
  description = "The root domain name used for email, without subdomains"
  type        = string
}

variable "gke_oidc_issuer_hostpath" {
  description = "The GKE cluster's OIDC issuer hostname and path. (The GKE cluster that sends email)"
  type        = string
}

variable "k8s_service_account_id" {
  description = "The ID of the ServiceAccount of the workload that sends the email in the k8s (GKE) cluser"
  type        = string
}

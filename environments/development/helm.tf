data "google_client_config" "provider" {}


provider "helm" {
  kubernetes {
    host  = "https://${google_container_cluster.primary.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
    )
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "gke-gcloud-auth-plugin"
    }
  }
}

resource "helm_release" "shortlist_runner" {
  name  = "dev"
  repository = "https://simoncrowe.github.io/helm"
  chart = "shortlist-runner"

  namespace        = "shortlist"
  create_namespace = true


  set {
    name  = "runner.assessorImage"
    value = "TBC"
  }

  set {
    name  = "runner.notifierUrl"
    value = "http://dev-shortlist-notifier.shortlist.svc.cluster.local/api/v1/notifcations"
  }

}

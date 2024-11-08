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

resource "helm_release" "runner" {
  name       = "run-dev"
  repository = "https://simoncrowe.github.io/helm"
  chart      = "shortlist-runner"

  namespace        = "shortlist"
  create_namespace = true

  set {
    name  = "runner.assessorImage"
    value = "ghcr.io/simoncrowe/shortlist-dummy-assessors:main"
  }

  set {
    name  = "runner.notifierUrl"
    value = "http://dev-shortlist-notifier.shortlist.svc.cluster.local/api/v1/notifcations"
  }

}

resource "helm_release" "rm_ingester" {
  for_each = var.rm_results_url == "" ? [] : toset(["enabled"])

  name       = "ingest-dev"
  repository = "https://simoncrowe.github.io/helm"
  chart      = "shortlist-rm-ingester"
  version    = "0.1.1"

  namespace        = "shortlist"
  create_namespace = true

  set {
    name  = "redis.hostname"
    value = "${helm_release.redis.name}-master.shortlist.svc.cluster.local"
  }
  set {
    name  = "redis.password"
    value = random_password.redis_password.result
  }
  set {
    name  = "ingester.runnerUrl"
    value = "http://${helm_release.runner.name}-shortlist-runner.shortlist.svc.cluster.local/api/v1/profiles"
  }
  set {
    name  = "ingester.resultsUrl"
    value = var.rm_results_url
  }

}

resource "random_password" "redis_password" {
  length  = 32
  special = true
}

resource "helm_release" "redis" {
  name       = "redis-dev"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "redis"

  namespace        = "shortlist"
  create_namespace = "true"

  set {
    name  = "architecture"
    value = "standalone"
  }
  set {
    name  = "auth.password"
    value = random_password.redis_password.result
  }
}

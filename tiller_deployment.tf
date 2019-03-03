resource "kubernetes_deployment" "tiller" {
  metadata {
    name      = "tiller-deploy"
    namespace = "${var.tiller_namespace}"
    labels    = "${local.labels}"
  }

  spec {
    replicas = 1

    selector {
      match_labels = "${local.labels}"
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge       = 1
        max_unavailable = 1
      }
    }

    template {
      metadata {
        labels = "${local.labels}"
      }

      spec {
        service_account_name = "${kubernetes_service_account.tiller.metadata.0.name}"

        container {
          name              = "${var.tiller_name}"
          image             = "gcr.io/kubernetes-helm/tiller:${var.tiller_version}"
          image_pull_policy = "IfNotPresent"

          env {
            name  = "TILLER_NAMESPACE"
            value = "${var.tiller_namespace}"
          }

          env {
            name  = "TILLER_HISTORY_MAX"
            value = "${var.tiller_history_max}"
          }

          port {
            container_port = "${local.tiller_container_port}"
            name           = "tiller"
          }

          port {
            container_port = "${local.http_container_port}"
            name           = "http"
          }

          liveness_probe {
            initial_delay_seconds = 1
            timeout_seconds       = 1
            period_seconds        = 10
            failure_threshold     = 3

            http_get {
              path = "/liveness"
              port = "${local.http_container_port}"
            }
          }

          readiness_probe {
            initial_delay_seconds = 1
            timeout_seconds       = 1
            period_seconds        = 10
            failure_threshold     = 3

            http_get {
              path = "/readiness"
              port = "${local.http_container_port}"
            }
          }

          volume_mount {
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name       = "${kubernetes_service_account.tiller.default_secret_name}"
            read_only  = true
          }
        }

        volume {
          name = "${kubernetes_service_account.tiller.default_secret_name}"

          secret {
            secret_name = "${kubernetes_service_account.tiller.default_secret_name}"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "tiller" {
  metadata {
    name      = "tiller-deploy"
    namespace = "${var.tiller_namespace}"
    labels    = "${local.labels}"
  }

  spec {
    selector = "${local.labels}"

    session_affinity = "None"

    port {
      name        = "tiller"
      port        = "${local.tiller_container_port}"
      target_port = "tiller"
    }

    type = "ClusterIP"
  }
}

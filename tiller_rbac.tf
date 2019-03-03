resource "kubernetes_role" "tiller" {
  metadata {
    name      = "${var.tiller_name}"
    namespace = "${var.tiller_namespace}"
    labels    = "${local.labels}"
  }

  rule {
    api_groups = ["", "batch", "extensions", "apps"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "${var.tiller_name}"
    namespace = "${var.tiller_namespace}"
    labels    = "${local.labels}"
  }
}

resource "kubernetes_role_binding" "tiller" {
  metadata {
    name      = "${var.tiller_name}"
    namespace = "${var.tiller_namespace}"
    labels    = "${local.labels}"
  }

  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = "${kubernetes_service_account.tiller.metadata.0.name}"
    namespace = "${var.tiller_namespace}"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "${kubernetes_role.tiller.metadata.0.name}"
  }
}

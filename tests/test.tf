provider "kubernetes" {
  config_context_cluster = "minikube"
}

module "tiller_test" {
  source = "../"
}

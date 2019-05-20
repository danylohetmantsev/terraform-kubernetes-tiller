provider "kubernetes" {
  config_context_cluster = "${var.config_context_cluster}"
}

variable "config_context_cluster" {
  type = "string"
}

variable "tiller_name" {
  default = "tiller"
}

variable "tiller_namespace" {
  default = "kube-system"
}

variable "tiller_version" {
  default = "v2.12.3"
}

variable "tiller_history_max" {
  default = "0"
}

variable "tiller_replicas" {
  default = "1"
}

variable "tiller_service_account" {
  default = ""
}

module "tiller_test" {
  source = "../"

  tiller_name            = "${var.tiller_name}"
  tiller_namespace       = "${var.tiller_namespace}"
  tiller_version         = "${var.tiller_version}"
  tiller_history_max     = "${var.tiller_history_max}"
  tiller_replicas        = "${var.tiller_replicas}"
  tiller_service_account = "${var.tiller_service_account}"
}

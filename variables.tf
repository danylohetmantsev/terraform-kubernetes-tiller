locals {
  http_container_port   = "44135"
  tiller_container_port = "44134"

  labels = {
    app  = "helm"
    name = "${var.tiller_name}"
  }
}

variable "tiller_name" {
  description = "Name of the objects associated with Tiller."
  default     = "tiller"
}

variable "tiller_namespace" {
  description = "Namespace where to deploy Tiller."
  default     = "kube-system"
}

variable "tiller_version" {
  description = "Tiller version to install. Use `canary` for using the canary image."
  default     = "v2.15.1"
}

variable "tiller_service_type" {
  description = "Tiller Service object type."
  default     = "ClusterIP"
}

variable "tiller_history_max" {
  description = "The maximum number of revisions saved per release. Use 0 for no limit."
  default     = "0"
}

variable "tiller_replicas" {
  description = "Amount of tiller instances to run on the cluster."
  default     = "1"
}

variable "tiller_service_account" {
  description = "Define it if you want to use an already existing ServiceAccount. If you leave it undefined the module will create a ServieAccount for Tiller."
  default     = ""
}

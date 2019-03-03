# terraform-helm-tiller

Terraform module for deploying Helm's Tiller on you k8s cluster.

## WORK IN PROGRESS

## Example usage

```hcl
provider "kubernetes" {
  config_context_auth_info = "ops"
  config_context_cluster   = "mycluster"
}

module "tiller"{
    source           = "github.com/Vidimensional/terraform-helm-tiller"
    tiller_name      = "tiller-mynamespace"
    tiller_namespace = "mynamespace"
}
```

## Argument Reference

The following arguments are supported:

* **tiller_name**: (optional) Name of the objects associated with Tiller. (default: tiller)

* **tiller_namespace**: (optional) Namespace where to deploy Tiller. (default: kube-system)

* **tiller_version**: (optional) Tiller version. (default: v2.12.3)

* **tiller_history_max**: (optional) The maximum number of revisions saved per release. Use 0 for no limit. (default: 0)

## TO-DO

The next steps on this project includes adding options that allows `helm init` command.
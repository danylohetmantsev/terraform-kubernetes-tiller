package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

var terraformOptions = &terraform.Options{
	TerraformDir: "./", // The path to where our Terraform code is located
	Vars: map[string]interface{}{
		"config_context_cluster": "niano",
	},
}

var k8sOptions = &k8s.KubectlOptions{
	Namespace: "kube-system",
}

func TestTerraformCreatesService(t *testing.T) {
	defer terraform.Destroy(t, terraformOptions)
	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	service := k8s.GetService(t, k8sOptions, "tiller-deploy")
	require.Equal(t, service.Name, "tiller-deploy")
}

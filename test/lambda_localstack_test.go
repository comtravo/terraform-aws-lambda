// +build localstack

package test

import (
	"fmt"
	"path"
	// "regexp"
	"testing"

	"github.com/gruntwork-io/terratest/modules/files"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// func TestVPCApplyEnabled_basic(t *testing.T) {
// 	t.Parallel()

// 	vpc_name := fmt.Sprintf("vpc_enabled-%s", random.UniqueId())

// 	terraformModuleVars := map[string]interface{}{
// 		"enable":             true,
// 		"vpc_name":           vpc_name,
// 		"subdomain":          "foo.bar.baz",
// 		"cidr":               "10.10.0.0/16",
// 		"availability_zones": []string{"us-east-1a", "us-east-1b", "us-east-1c"},
// 		"tags": map[string]string{
// 			"Name": vpc_name,
// 		},
// 		"nat_gateway": map[string]string{
// 			"behavior": "one_nat_per_vpc",
// 		},
// 		"enable_dns_support":               true,
// 		"assign_generated_ipv6_cidr_block": true,
// 		"private_subnets": map[string]int{
// 			"number_of_subnets": 3,
// 			"newbits":           8,
// 			"netnum_offset":     0,
// 		},
// 		"public_subnets": map[string]int{
// 			"number_of_subnets": 3,
// 			"newbits":           8,
// 			"netnum_offset":     100,
// 		},
// 	}

// 	terraformOptions := SetupTestCase(t, terraformModuleVars)
// 	t.Logf("Terraform module inputs: %+v", *terraformOptions)
// 	// defer terraform.Destroy(t, terraformOptions)

// 	terraform.InitAndApply(t, terraformOptions)
// 	ValidateTerraformModuleOutputs(t, terraformOptions)
// 	ValidateNATGateways(t, terraformOptions, 1)
// 	ValidatePrivateRoutingTables(t, terraformOptions, 1)
// 	ValidateElasticIps(t, terraformOptions, 1)
// }

func TestLambda_apiGateway(t *testing.T) {
	t.Parallel()

	function_name := fmt.Sprintf("lambda-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"file_name":     "foo.zip",
		"function_name": function_name,
		"handler":       "index.handler",
		"role":          function_name,
		"trigger": map[string]string{
			"type": "api-gateway",
		},
		"environment": map[string]string{
			"LOREM": "ipsum",
		},
		"region": "us-east-1",
		"tags": map[string]string{
			"Foo": function_name,
		},
	}

	terraformOptions := SetupTestCase(t, terraformModuleVars)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)

	terraformApplyOutput := terraform.InitAndApply(t, terraformOptions)
	resourceCount := terraform.GetResourceCount(t, terraformApplyOutput)
	require.Greater(t, resourceCount.Add, 0)
	require.Equal(t, resourceCount.Change, 0)
	require.Equal(t, resourceCount.Destroy, 0)
}

func SetupTestCase(t *testing.T, terraformModuleVars map[string]interface{}) *terraform.Options {
	testRunFolder, err := files.CopyTerraformFolderToTemp("../", t.Name())
	require.NoError(t, err)
	t.Logf("Copied files to test folder: %s", testRunFolder)

	localstackConfigDestination := path.Join(testRunFolder, "localstack.tf")
	files.CopyFile("fixtures/localstack.tf", localstackConfigDestination)
	t.Logf("Copied localstack file to: %s", localstackConfigDestination)

	lambdaConfigDestination := path.Join(testRunFolder, "lambda.tf")
	files.CopyFile("fixtures/lambda.tf", lambdaConfigDestination)
	t.Logf("Copied lambda file to: %s", lambdaConfigDestination)

	lambdaFunctionDestination := path.Join(testRunFolder, "foo.zip")
	files.CopyFile("fixtures/foo.zip", lambdaFunctionDestination)
	t.Logf("Copied lambda file to: %s", lambdaFunctionDestination)

	terraformOptions := &terraform.Options{
		TerraformDir: testRunFolder,
		Vars:         terraformModuleVars,
	}
	return terraformOptions
}

// func SetupExternalElasticIPs(t *testing.T, terraformOptions *terraform.Options) {
// 	externalElasticIPsFileDestination := path.Join(terraformOptions.TerraformDir, "eip.tf")
// 	files.CopyFile("fixtures/eip.tf", externalElasticIPsFileDestination)
// 	t.Logf("Copied eip file to: %s", externalElasticIPsFileDestination)

// 	terraformOptions.Targets = []string{"aws_eip.external"}
// 	t.Logf("Terraform module inputs for Elastic IPs: %+v", *terraformOptions)
// 	terraformApplyOutput := terraform.InitAndApply(t, terraformOptions)
// 	resourceCount := terraform.GetResourceCount(t, terraformApplyOutput)
// 	external_elastic_ips := terraform.OutputList(t, terraformOptions, "external_elastic_ips")

// 	exptected_external_eip_count := terraformOptions.Vars["external_eip_count"].(int)

// 	require.Equal(t, resourceCount.Add, exptected_external_eip_count)
// 	require.Equal(t, resourceCount.Change, 0)
// 	require.Equal(t, resourceCount.Destroy, 0)
// 	require.Len(t, external_elastic_ips, exptected_external_eip_count)

// 	t.Logf("External elastic IPs created: %s", external_elastic_ips)

// 	terraformOptions.Targets = []string{}
// 	terraformOptions.Vars["external_elastic_ips"] = external_elastic_ips
// }

// func ValidateTerraformModuleOutputs(t *testing.T, terraformOptions *terraform.Options) {
// }

// +build localstack

package test

import (
	"fmt"
	"path"
	"regexp"
	// "strconv"
	"testing"

	"github.com/gruntwork-io/terratest/modules/files"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

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

	TerraformApplyAndValidateOutputs(t, terraformOptions)
	require.Regexp(t, regexp.MustCompile("arn:aws:apigateway:us-east-1:lambda:path/*"), terraform.Output(t, terraformOptions, "invoke_arn"))
}

func TestLambda_layers(t *testing.T) {
	t.Parallel()

	function_name := fmt.Sprintf("lambda-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"file_name":     "foo.zip",
		"function_name": function_name,
		"handler":       "index.handler",
		"role":          function_name,
		"layers":        []string{"arn:aws:lambda:us-east-1:284387765956:layer:BetterSqlite3:8"},
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

	TerraformApplyAndValidateOutputs(t, terraformOptions)

	require.Regexp(t, regexp.MustCompile("arn:aws:apigateway:us-east-1:lambda:path/*"), terraform.Output(t, terraformOptions, "invoke_arn"))
}

func TestLambda_publish(t *testing.T) {
	t.Parallel()

	function_name := fmt.Sprintf("lambda-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"file_name":     "foo.zip",
		"function_name": function_name,
		"handler":       "index.handler",
		"role":          function_name,
		"publish":       true,
		"layers":        []string{"arn:aws:lambda:us-east-1:284387765956:layer:BetterSqlite3:8"},
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

	TerraformApplyAndValidateOutputs(t, terraformOptions)
	require.Equal(t, "1", terraform.Output(t, terraformOptions, "version"))
	require.Regexp(t, terraform.Output(t, terraformOptions, "qualified_arn"), fmt.Sprintf("arn:aws:lambda:us-east-1:000000000000:function:%s:1", terraformOptions.Vars["function_name"]))
}

func TestLambda_cloudwatchEventSchedule(t *testing.T) {
	t.Parallel()

	function_name := fmt.Sprintf("lambda-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"file_name":     "foo.zip",
		"function_name": function_name,
		"handler":       "index.handler",
		"role":          function_name,
		"trigger": map[string]string{
			"type":                "cloudwatch-event-schedule",
			"schedule_expression": "cron(0 1 * * ? *)",
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

	TerraformApplyAndValidateOutputs(t, terraformOptions)
}

func TestLambda_cloudwatchEventTrigger(t *testing.T) {
	t.Parallel()

	function_name := fmt.Sprintf("lambda-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"file_name":     "foo.zip",
		"function_name": function_name,
		"handler":       "index.handler",
		"role":          function_name,
		"trigger": map[string]string{
			"type":          "cloudwatch-event-trigger",
			"event_pattern": "{}",
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

	TerraformApplyAndValidateOutputs(t, terraformOptions)
}

func TestLambda_stepfunction(t *testing.T) {
	t.Parallel()

	function_name := fmt.Sprintf("lambda-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"file_name":     "foo.zip",
		"function_name": function_name,
		"handler":       "index.handler",
		"role":          function_name,
		"trigger": map[string]string{
			"type": "step-function",
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

	TerraformApplyAndValidateOutputs(t, terraformOptions)
}

func TestLambda_cognitoIDP(t *testing.T) {
	t.Parallel()

	function_name := fmt.Sprintf("lambda-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"file_name":     "foo.zip",
		"function_name": function_name,
		"handler":       "index.handler",
		"role":          function_name,
		"trigger": map[string]string{
			"type": "cognito=idp",
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

	TerraformApplyAndValidateOutputs(t, terraformOptions)
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

func TerraformApplyAndValidateOutputs(t *testing.T, terraformOptions *terraform.Options) {
	terraformApplyOutput := terraform.InitAndApply(t, terraformOptions)
	resourceCount := terraform.GetResourceCount(t, terraformApplyOutput)

	require.Greater(t, resourceCount.Add, 0)
	require.Equal(t, resourceCount.Change, 0)
	require.Equal(t, resourceCount.Destroy, 0)

	require.Regexp(t, terraform.Output(t, terraformOptions, "arn"), fmt.Sprintf("arn:aws:lambda:us-east-1:000000000000:function:%s", terraformOptions.Vars["function_name"]))
}

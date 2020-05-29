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

func TestLambda_apiGatewayTriggerExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/api_gateway_trigger/"

	terraformOptions := SetupExample(t, functionName, exampleDir)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
	require.Regexp(t, regexp.MustCompile("arn:aws:apigateway:us-east-1:lambda:path/*"), terraform.Output(t, terraformOptions, "invoke_arn"))
}

func TestLambda_layersExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/layers/"

	terraformOptions := SetupExample(t, functionName, exampleDir)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
	require.Regexp(t, regexp.MustCompile("arn:aws:apigateway:us-east-1:lambda:path/*"), terraform.Output(t, terraformOptions, "invoke_arn"))
}

func TestLambda_publishExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/publish/"

	terraformOptions := SetupExample(t, functionName, exampleDir)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
	require.Equal(t, "1", terraform.Output(t, terraformOptions, "version"))
	require.Regexp(t, terraform.Output(t, terraformOptions, "qualified_arn"), fmt.Sprintf("arn:aws:lambda:us-east-1:000000000000:function:%s:1", terraformOptions.Vars["function_name"]))
}

func TestLambda_cloudwatchEventScheduleTriggerExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/cloudwatch_event_schedule_trigger/"

	terraformOptions := SetupExample(t, functionName, exampleDir)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
}

func TestLambda_cloudwatchEventPatternTriggerExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/cloudwatch_event_pattern_trigger/"

	terraformOptions := SetupExample(t, functionName, exampleDir)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
}

func TestLambda_stepfunctionTriggerExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/step_function_trigger/"

	terraformOptions := SetupExample(t, functionName, exampleDir)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
}

func TestLambda_cognitoTriggerExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/cognito_trigger/"

	terraformOptions := SetupExample(t, functionName, exampleDir)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
}

func TestLambda_cloudwatchLogsTriggerExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/cloudwatch_logs_trigger/"

	terraformOptions := SetupExample(t, functionName, exampleDir)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
}

func TestLambda_sqsTriggerExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/sqs_trigger/"

	terraformOptions := SetupExample(t, functionName, exampleDir)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
	ValidateSQSTriggerOutputs(t, terraformOptions, false)
}

func TestLambda_sqsFifoTriggerExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/sqs_fifo_trigger/"

	terraformOptions := SetupExample(t, functionName, exampleDir)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
	ValidateSQSTriggerOutputs(t, terraformOptions, true)
}

// func TestLambda_cloudwatchLogsSubscription(t *testing.T) {
// 	t.Skip()

// 	lambdaLogConsumerName := fmt.Sprintf("lambda-%s", random.UniqueId())

// 	lambdaLogConsumerVars := map[string]interface{}{
// 		"file_name":     "foo.zip",
// 		"function_name": lambdaLogConsumerName,
// 		"handler":       "index.handler",
// 		"role":          lambdaLogConsumerName,
// 		"trigger": map[string]string{
// 			"type": "cloudwatch-logs",
// 		},
// 		"environment": map[string]string{
// 			"LOREM": "ipsum",
// 		},
// 		"region": "us-east-1",
// 		"tags": map[string]string{
// 			"Foo": lambdaLogConsumerName,
// 		},
// 	}

// 	lambdaLogConsumerOptions := SetupTestCase(t, lambdaLogConsumerVars)
// 	t.Logf("Terraform module inputs: %+v", *lambdaLogConsumerOptions)
// 	TerraformApplyAndValidateOutputs(t, lambdaLogConsumerOptions)

// 	lambdaLogGeneratorName := fmt.Sprintf("lambda-%s", random.UniqueId())
// 	lambdaLogGeneratorVars := map[string]interface{}{
// 		"file_name":     "foo.zip",
// 		"function_name": lambdaLogGeneratorName,
// 		"handler":       "index.handler",
// 		"role":          lambdaLogGeneratorName,
// 		"trigger": map[string]string{
// 			"type": "cognito-idp",
// 		},
// 		"cloudwatch_log_subscription": map[string]interface{}{
// 			"enable":          true,
// 			"filter_pattern":  "[]",
// 			"destination_arn": terraform.Output(t, lambdaLogConsumerOptions, "arn"),
// 		},
// 		"environment": map[string]string{
// 			"LOREM": "ipsum",
// 		},
// 		"region": "us-east-1",
// 		"tags": map[string]string{
// 			"Foo": lambdaLogGeneratorName,
// 		},
// 	}

// 	lambdaLogGeneratorOptions := SetupTestCase(t, lambdaLogGeneratorVars)
// 	t.Logf("Terraform module inputs: %+v", *lambdaLogGeneratorOptions)
// 	TerraformApplyAndValidateOutputs(t, lambdaLogGeneratorOptions)
// }

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

func SetupExample(t *testing.T, functionName string, exampleDir string) *terraform.Options {

	localstackConfigDestination := path.Join(exampleDir, "localstack.tf")
	files.CopyFile("fixtures/localstack.tf", localstackConfigDestination)
	t.Logf("Copied localstack file to: %s", localstackConfigDestination)

	lambdaFunctionDestination := path.Join(exampleDir, "foo.zip")
	files.CopyFile("fixtures/foo.zip", lambdaFunctionDestination)
	t.Logf("Copied lambda file to: %s", lambdaFunctionDestination)

	terraformOptions := &terraform.Options{
		TerraformDir: exampleDir,
		Vars: map[string]interface{}{
			"function_name": functionName,
		},
	}
	return terraformOptions
}

func TerraformApplyAndValidateOutputs(t *testing.T, terraformOptions *terraform.Options) {
	terraformApplyOutput := terraform.InitAndApply(t, terraformOptions)
	resourceCount := terraform.GetResourceCount(t, terraformApplyOutput)

	require.Greater(t, resourceCount.Add, 0)
	require.Equal(t, resourceCount.Change, 0)
	require.Equal(t, resourceCount.Destroy, 0)

	require.Regexp(t, terraform.Output(t, terraformOptions, "arn"), fmt.Sprintf("arn:aws:lambda:us-east-1:000000000000:function:%s", terraformOptions.Vars["function_name"]))
}

func ValidateSQSTriggerOutputs(t *testing.T, terraformOptions *terraform.Options, isFifo bool) {
	dlq := terraform.OutputMap(t, terraformOptions, "dlq")
	queue := terraform.OutputMap(t, terraformOptions, "queue")

	expectedDlqName := fmt.Sprintf("%s-dlq", terraformOptions.Vars["function_name"])
	expectedQueueName := fmt.Sprintf("%s", terraformOptions.Vars["function_name"])

	if isFifo == true {
		expectedDlqName = fmt.Sprintf("%s.fifo", expectedDlqName)
		expectedQueueName = fmt.Sprintf("%s.fifo", expectedQueueName)
	}

	require.Equal(t, fmt.Sprintf("arn:aws:sqs:us-east-1:000000000000:%s", expectedDlqName), dlq["arn"])
	require.Regexp(t, regexp.MustCompile("http://*"), dlq["id"])
	require.Regexp(t, regexp.MustCompile("http://*"), dlq["url"])
	require.Equal(t, dlq["id"], dlq["url"])

	require.Equal(t, fmt.Sprintf("arn:aws:sqs:us-east-1:000000000000:%s", expectedQueueName), queue["arn"])
	require.Regexp(t, regexp.MustCompile("http://*"), queue["id"])
	require.Regexp(t, regexp.MustCompile("http://*"), queue["url"])
	require.Equal(t, queue["id"], queue["url"])

	require.NotEqual(t, queue["id"], dlq["id"])
	require.NotEqual(t, queue["arn"], dlq["arn"])

}

// +build aws

package test

import (
	"fmt"
	"path"
	"regexp"
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

	terraformOptions := SetupExample(t, functionName, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
	require.Regexp(t, regexp.MustCompile("arn:aws:apigateway:us-east-1:lambda:path/*"), terraform.Output(t, terraformOptions, "invoke_arn"))
}

func TestLambda_kinesisTriggerBasicExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/kinesis_basic/"

	terraformOptions := SetupExample(t, functionName, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
}

func TestLambda_kinesisTriggerMultipleExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/kinesis_multiple/"

	terraformOptions := SetupExample(t, functionName, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
}

func TestLambda_noEnvironmentVariables(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/no_environment_variables/"

	terraformOptions := SetupExample(t, functionName, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
	require.Regexp(t, regexp.MustCompile("arn:aws:apigateway:us-east-1:lambda:path/*"), terraform.Output(t, terraformOptions, "invoke_arn"))
}

func TestLambda_layersExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/layers/"

	terraformOptions := SetupExample(t, functionName, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
	require.Regexp(t, regexp.MustCompile("arn:aws:apigateway:us-east-1:lambda:path/*"), terraform.Output(t, terraformOptions, "invoke_arn"))
}

func TestLambda_publishExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/publish/"

	terraformOptions := SetupExample(t, functionName, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
	require.Equal(t, "1", terraform.Output(t, terraformOptions, "version"))
	require.Regexp(t,
		regexp.MustCompile(fmt.Sprintf("arn:aws:lambda:us-east-1:\\d{12}:function:%s:1", terraformOptions.Vars["function_name"])),
		terraform.Output(t, terraformOptions, "qualified_arn"),
	)
}

func TestLambda_cloudwatchEventScheduleTriggerExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/cloudwatch_event_schedule_trigger/"

	terraformOptions := SetupExample(t, functionName, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
}

func TestLambda_nullTriggerExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/null_trigger/"

	terraformOptions := SetupExample(t, functionName, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
}

func TestLambda_dockerImageBasic(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/docker_image_basic/"

	terraformOptions := SetupExample(t, functionName, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
}

func TestLambda_cloudwatchEventPatternTriggerExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/cloudwatch_event_pattern_trigger/"

	terraformOptions := SetupExample(t, functionName, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
}

func TestLambda_stepfunctionTriggerExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/step_function_trigger/"

	terraformOptions := SetupExample(t, functionName, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
}

func TestLambda_cognitoTriggerExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/cognito_trigger/"

	terraformOptions := SetupExample(t, functionName, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
}

func TestLambda_cloudwatchLogsTriggerExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/cloudwatch_logs_trigger/"

	terraformOptions := SetupExample(t, functionName, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
}

func TestLambda_sqsTriggerExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/sqs_trigger/"

	terraformOptions := SetupExample(t, functionName, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
	ValidateSQSTriggerOutputs(t, terraformOptions, false)
}

func TestLambda_sqsSnsTriggerExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/sqs_sns_trigger/"
	sns_targets := []string{"aws_sns_topic.foo", "aws_sns_topic.bar", "aws_sns_topic.baz"}

	snsTerraformOptions := SetupExample(t, functionName, exampleDir, sns_targets)
	t.Logf("Terraform module inputs: %+v", *snsTerraformOptions)
	terraform.InitAndApply(t, snsTerraformOptions)

	terraformOptions := SetupExample(t, functionName, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)
	TerraformApplyAndValidateOutputs(t, terraformOptions)
	ValidateSQSTriggerOutputs(t, terraformOptions, false)
}

func TestLambda_sqsFifoTriggerExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/sqs_fifo_trigger/"

	terraformOptions := SetupExample(t, functionName, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
	ValidateSQSTriggerOutputs(t, terraformOptions, true)
}

func TestLambda_sqsFifoSnsTriggerExample(t *testing.T) {
	t.Parallel()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/sqs_fifo_sns_trigger/"

	sns_targets := []string{"aws_sns_topic.foo", "aws_sns_topic.bar", "aws_sns_topic.baz"}

	snsTerraformOptions := SetupExample(t, functionName, exampleDir, sns_targets)
	t.Logf("Terraform module inputs: %+v", *snsTerraformOptions)
	terraform.InitAndApply(t, snsTerraformOptions)

	terraformOptions := SetupExample(t, functionName, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
	ValidateSQSTriggerOutputs(t, terraformOptions, false)
}

func TestLambda_cloudwatchLogSubscriptionExample(t *testing.T) {
	t.Skip()

	functionName := fmt.Sprintf("lambda-%s", random.UniqueId())
	exampleDir := "../examples/cloudwatch_logs_subscription/"

	terraformOptions := SetupExample(t, functionName, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
	ValidateSQSTriggerOutputs(t, terraformOptions, false)
}

func SetupExample(t *testing.T, functionName string, exampleDir string, targets []string) *terraform.Options {
	lambdaFunctionDestination := path.Join(exampleDir, "foo.zip")
	files.CopyFile("fixtures/foo.zip", lambdaFunctionDestination)
	t.Logf("Copied lambda file to: %s", lambdaFunctionDestination)

	terraformOptions := &terraform.Options{
		TerraformDir: exampleDir,
		Vars: map[string]interface{}{
			"function_name": functionName,
		},
		Targets: targets,
	}
	return terraformOptions
}

func TerraformApplyAndValidateOutputs(t *testing.T, terraformOptions *terraform.Options) {
	terraformApplyOutput := terraform.InitAndApply(t, terraformOptions)
	resourceCount := terraform.GetResourceCount(t, terraformApplyOutput)

	require.Greater(t, resourceCount.Add, 0)
	require.Equal(t, resourceCount.Change, 0)
	require.Equal(t, resourceCount.Destroy, 0)

	require.Regexp(t, regexp.MustCompile(fmt.Sprintf("arn:aws:lambda:us-east-1:\\d{12}:function:%s", terraformOptions.Vars["function_name"])), terraform.Output(t, terraformOptions, "arn"))
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

	require.Regexp(t, regexp.MustCompile(fmt.Sprintf("arn:aws:sqs:us-east-1:\\d{12}:%s", expectedDlqName)), dlq["arn"])
	require.Regexp(t, regexp.MustCompile("https://*"), dlq["id"])
	require.Regexp(t, regexp.MustCompile("https://*"), dlq["url"])
	require.Equal(t, dlq["id"], dlq["url"])

	require.Regexp(t, fmt.Sprintf("arn:aws:sqs:us-east-1:\\d{12}:%s", expectedQueueName), queue["arn"])
	require.Regexp(t, regexp.MustCompile("https://*"), queue["id"])
	require.Regexp(t, regexp.MustCompile("https://*"), queue["url"])
	require.Equal(t, queue["id"], queue["url"])

	require.NotEqual(t, queue["id"], dlq["id"])
	require.NotEqual(t, queue["arn"], dlq["arn"])
}

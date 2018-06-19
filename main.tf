module "label" {
  source                  = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.1"

  namespace               = "${var.namespace}"
  stage                   = "${var.environment}"
  name                    = "${var.name}"

  tags                    = "${var.tags}"
}

resource "aws_api_gateway_resource" "this" {
  count               = "${var.endpoint != "" ? 1 : 0}"
  rest_api_id         = "${var.api_id}"
  parent_id           = "${var.parent_resource_id}"

  path_part           = "${var.endpoint}"
}

resource "aws_api_gateway_method" "this_auth" {
  depends_on          = ["aws_api_gateway_method.this_no_auth"]
  count               = "${var.http_method != "" && var.authorizer_id != "" ? 1 : 0}"

  rest_api_id         = "${var.api_id}"
  resource_id         = "${var.endpoint != "" ? element(aws_api_gateway_resource.this.*.id, 0) : var.endpoint_id}"
  http_method         = "${var.http_method}"
  
  authorization       = "CUSTOM"
  authorizer_id       = "${var.authorizer_id}"

  api_key_required    = "${var.api_key_required}"
  request_models      = "${var.request_models}"
  request_parameters  = "${var.request_parameters}"
}

resource "aws_api_gateway_method" "this_no_auth" {
  count               = "${var.http_method != "" && var.authorizer_id == "" ? 1 : 0}"

  rest_api_id         = "${var.api_id}"
  resource_id         = "${var.endpoint != "" ? element(aws_api_gateway_resource.this.*.id, 0) : var.endpoint_id}"
  http_method         = "${var.http_method}"
  
  authorization       = "NONE"

  api_key_required    = "${var.api_key_required}"
  request_models      = "${var.request_models}"
  request_parameters  = "${var.request_parameters}"
}

resource "aws_api_gateway_integration" "this" {
  depends_on              = ["aws_api_gateway_resource.this", "aws_api_gateway_method.this_auth", "aws_api_gateway_method.this_no_auth"]
  rest_api_id             = "${var.api_id}"
  resource_id             = "${var.endpoint != "" ? element(aws_api_gateway_resource.this.*.id, 0) : var.endpoint_id}"
  http_method             = "${element(concat(aws_api_gateway_method.this_auth.*.http_method, aws_api_gateway_method.this_no_auth.*.http_method, list("")), 0)}"

  integration_http_method = "POST"
  type                    = "AWS"

  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${module.lambda.arn}/invocations"

  request_templates       = "${var.request_templates}"
  passthrough_behavior    = "NEVER"
}

resource "aws_lambda_permission" "this" {
  function_name           = "${module.lambda.arn}"
  statement_id            = "AllowExecutionFromApiGateway"
  action                  = "lambda:InvokeFunction"
  principal               = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn              = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${var.api_id}/*/${var.http_method}${aws_api_gateway_resource.this.path}"
}

module "lambda" {
  source                  = "git::https://github.com/boitewitte/terraform-aws-lambda.git"

  namespace               = "${var.namespace}"
  environment             = "${var.environment}"
  name                    = "${var.name}"

  filename                = "${var.lambda_filename}"
  handler                 = "${var.lambda_handler}"
  runtime                 = "${var.lambda_runtime}"
  source_code_hash        = "${var.lambda_code_hash}"
  memory_size             = "${var.lambda_memory_size}"
  timeout                 = "${var.lambda_timeout}"
  execution_policies      = ["${var.lambda_execution_policies}"]
  execution_policies_count  = "${var.lambda_execution_policies_count}"

  environment_variables   = "${merge(module.label.tags, var.lambda_environment_variables)}"
  dead_letter_config      = "${var.lambda_dead_letter_config}"
  logs_policy             = "${format("%s-logs-policy", module.label.id)}"

  tags                    = "${module.label.tags}"

  vpc_subnet_ids          = "${var.lambda_vpc_subnet_ids}"
  vpc_security_group_ids  = "${var.lambda_vpc_security_group_ids}"
}

resource "aws_api_gateway_method_settings" "this" {
  count       = "${length(values(var.method_settings)) > 0 ? 1 : 0}"

  rest_api_id = "${var.api_id}"
  stage_name  = "${var.environment}"

  method_path = "${var.endpoint != "" ? element(aws_api_gateway_resource.this.*.path_part, 0) : var.endpoint_path}/${var.http_method}"

  settings    = "${var.method_settings}"
}


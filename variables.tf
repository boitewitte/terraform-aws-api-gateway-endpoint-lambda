variable "aws_region" {
  type = "string"
  description = "AWS:region"
}

variable "aws_account_id" {
  type = "string"
  description = "AWS:account_id"
}

variable "namespace" {
  type = "string"
  description = "The namespace for the Lambda function"
}

variable "environment" {
  type = "string"
  description = "The environment (stage) for the Lambda function"
}

variable "name" {
  type = "string"
  description = "The name for the Lambda function"
}

variable "tags" {
  type = "map"
  description = "describe your variable"
  default = {}
}

variable "api_id" {
  type = "string"
  description = "The ID of the associated REST API"
}

variable "parent_resource_id" {
  type = "string"
  description = "The ID of the parent API resource"
}

variable "endpoint" {
  type = "string"
  description = "The last path segment of this API resource."
  default = ""
}

variable "endpoint_id" {
  description = "The Resource ID for the endpoint, if set no endpoint will be generated (default is false)"
  default = false
}

variable "endpoint_path" {
  type = "string"
  description = "The Resource path for the endpoint."
  default = ""
}

variable "http_method" {
  type = "string"
  description = "The HTTP Method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY)"
  default = ""
}

variable "authorizer_id" {
  type = "string"
  description = "The authorizer id to be used when the authorization is CUSTOM"
  default = ""
}

variable "api_key_required" {
  description = "describe your variable"
  default = false
}

variable "request_models" {
  type = "map"
  description = "A map of the API models used for the request's content type where key is the content type"
  default = {}
}

variable "request_parameters" {
  type = "map"
  description = "A map of request query string parameters and headers that should be passed to the integration."
  default = {
    "method.request.header.Authorization" = true
  }
}

variable "request_templates" {
  type = "map"
  description = "A map of the integration's request templates."
  default = {}
}

variable "lambda_code_hash" {
  type = "string"
  description = "Used to trigger updates. Must be set to a base64-encoded SHA256 hash of the package file specified with either filename or s3_key."
}

variable "lambda_dead_letter_config" {
  type = "map"
  description = "Nested block to configure the function's dead letter queue."
  default = {}
}

variable "lambda_filename" {
  type = "string"
  description = "The path to the function's deployment package within the local filesystem."
}

variable "lambda_handler" {
  type = "string"
  description = "The function entrypoint in your code."
}

variable "lambda_environment_variables" {
  type = "map"
  description = "A map that defines environment variables for the Lambda function."
  default = {}
}

variable "lambda_memory_size" {
  type = "string"
  description = "Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128."
  default = "128"
}

variable "lambda_runtime" {
  type = "string"
  description = "The runtime environment for the Lambda function you are uploading. (nodejs, nodejs4.3, nodejs6.10, java8, python2.7, python3.6, dotnetcore1.0, nodejs4.3-edge)"
}

variable "lambda_timeout" {
  type = "string"
  description = "The amount of time your Lambda Function has to run in seconds. Defaults to 3."
  default = "3"
}

variable "lambda_execution_policies" {
  type = "list"
  description = "List of Lambda Execution Policy ARNs"
  default = []
}

variable "lambda_execution_policies_count" {
  type = "string"
  description = "Workaround for list of resources count"
  default = "0"
}

variable "lambda_vpc_subnet_ids" {
  type = "list"
  description = "A list of subnet IDs associated with the Lambda function."
  default = []
}

variable "lambda_vpc_security_group_ids" {
  type = "list"
  description = "A list of security group IDs associated with the Lambda function."
  default = []
}

variable "lambda_logs_policy" {
  description = "Create a policy for the logs. If true, then the logs policy will be create"
  default = true
}

variable "lambda_alias_name" {
  description = "Name for the alias you are creating. Pattern: (?!^[0-9]+$)([a-zA-Z0-9-_]+), when false no alias is created"
  default = false
}

variable "lambda_alias_description" {
  description = "Description of the alias."
  default = false
}

variable "lambda_alias_version" {
  description = "Lambda function version for which you are creating the alias."
  default     = false
}

variable "lambda_es_arn" {
  description = "The event source ARN - can either be a Kinesis or DynamoDB stream. When false, no event stream is created"
  default     = false
}

variable "lambda_es_enabled" {
  description = "Determines if the mapping will be enabled on creation. Defaults to true"
  default = true
}

variable "lambda_es_batch_size" {
  description = "The largest number of records that Lambda will retrieve from your event source at the time of invocation. Defaults to 100."
  default = 100
}

variable "lambda_es_starting_position" {
  description = "The position in the stream where AWS Lambda should start reading. Can be one of either TRIM_HORIZON or LATEST."
  default = false
}

variable "method_settings" {
  type = "map"
  description = "Provides an API Gateway Method Settings"
  default = {}
}

output "api_id" {
  value = "${var.api_id}"
}

output "endpoint_id" {
  value = "${var.endpoint != "" ? element(concat(aws_api_gateway_resource.this.*.id, list("")), 0) : var.endpoint_id}"
}

output "endpoint_path" {
  value = "${var.endpoint != "" ? element(concat(aws_api_gateway_resource.this.*.path_part, list("")), 0) : var.endpoint_path}"
}

output "http_method" {
  value = "${aws_api_gateway_integration.this.http_method}"
}

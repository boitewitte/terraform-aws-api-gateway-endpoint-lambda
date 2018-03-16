output "api_id" {
  value = "${var.api_id}"
}

output "endpoint_id" {
  value = "${aws_api_gateway_resource.this.id}"
}

output "endpoint_path" {
  value = "${aws_api_gateway_resource.this.path}"
}

output "http_method" {
  value = "${element(concat(aws_api_gateway_method.this_auth.*.http_method, aws_api_gateway_method.this_no_auth.*.http_method, list("")), 0)}"
}

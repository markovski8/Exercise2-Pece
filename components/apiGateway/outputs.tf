# output "api_gateway_execution_arn" {
#   value = aws_api_gateway_rest_api.api_gateway.execution_arn
# }
output "api_gateway_execution_arn" {
  value = "arn:aws:apigateway:${var.region}::/restapis/${aws_api_gateway_rest_api.api_gateway.id}/stages/${aws_api_gateway_stage.stages.stage_name}"
}


output "http_method_output" {
  value = aws_api_gateway_method.post_method.http_method
}
output "api_gateway_id" {
  value = aws_api_gateway_rest_api.api_gateway.id
}
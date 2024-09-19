output "lambda_invoke_arn" {
  value = aws_lambda_function.apilambda.invoke_arn
}

output "lambda_function_name" {
  value = aws_lambda_function.apilambda.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.apilambda.arn
}

# output "api_gateway_id" {
#   value = aws_api_gateway_rest_api.api_gateway.id
# }
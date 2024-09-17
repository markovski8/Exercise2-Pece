output "lambda_function_arn" {
  value = aws_lambda_function.apilambda.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.apilambda.function_name
}
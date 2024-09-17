module "lambda" {
  source = "./components/lambda"
  api_gateway_execution_arn = module.apiGateway.api_gateway_execution_arn
}

module "apiGateway" {
  source               = "./components/apiGateway"
  lambda_function_arn  = module.lambda.lambda_function_arn
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.apiGateway.api_gateway_execution_arn}/*/*"
}

module "sns" {
  source = "./components/sns"
  email = var.email
}


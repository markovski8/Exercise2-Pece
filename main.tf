# module "tfstate" {
#     source = "./Components/tfstate"
# }
module "lambda" {
  source = "./components/lambda"
  api_gateway_execution_arn = module.apiGateway.api_gateway_execution_arn
  sns_topic_arn = module.sns.sns_topic_arn
  lambda_invoke_arn = var.lambda_invoke_arn
  lambda_function_name = var.lambda_function_name
}

module "apiGateway" {
  region = var.region
  source               = "./components/apiGateway"
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
  lambda_function_arn = module.lambda.lambda_function_arn
  lambda_function_name = module.lambda.lambda_function_name
  http_method = "POST"
}


resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:${module.apiGateway.api_gateway_id}/*/*/*"
}

module "sns" {
  source = "./components/sns"
  email = var.email
}
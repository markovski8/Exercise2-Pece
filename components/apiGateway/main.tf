resource "aws_api_gateway_rest_api" "api_gateway" {
  name = "orderApi"
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part = "api_resource"
}

resource "aws_api_gateway_method" "post_method" {
  resource_id   = aws_api_gateway_resource.api_resource.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  authorization = "NONE"
  http_method   = "POST"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  depends_on  = [aws_api_gateway_method.post_method]
  resource_id = aws_api_gateway_resource.api_resource.id
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  http_method = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type        = "AWS_PROXY"
  uri         = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}/invocations"
}
resource "aws_api_gateway_deployment" "api_deploy" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  # stage_name = "dev"
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  
}

resource "aws_api_gateway_stage" "stages" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name = "dev"
  deployment_id = aws_api_gateway_deployment.api_deploy.id
 
}

# data "aws_region" "current" {}
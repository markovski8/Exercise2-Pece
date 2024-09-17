resource "aws_apigatewayv2_api" "api_gateway" {
  name           = "orderApi"
  protocol_type  = "HTTP"
}

resource "aws_apigatewayv2_stage" "stages" {
  api_id        = aws_apigatewayv2_api.api_gateway.id
  name          = "dev"  
  auto_deploy   = true
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                   = aws_apigatewayv2_api.api_gateway.id
  integration_type         = "AWS_PROXY"
  integration_uri          = var.lambda_function_arn
  payload_format_version   = "2.0"
}

resource "aws_apigatewayv2_route" "post_trigger" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "POST /trigger"  

  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}



data "aws_region" "current" {}
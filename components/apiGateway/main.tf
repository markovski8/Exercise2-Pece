resource "aws_apigatewayv2_api" "api-gateway" {
  name  = "orderApi"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "stages" {
  api_id = aws_apigatewayv2_api.api-gateway.id
  name = "dev"  
}

resource "aws_apigatewayv2_integration" "aws-integration" {
  api_id = aws_apigatewayv2_api.api-gateway.id
  integration_type = "AWS_PROXY"
  integration_uri = aws
  
}
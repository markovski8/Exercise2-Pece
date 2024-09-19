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

resource "aws_api_gateway_method_settings" "example" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = aws_api_gateway_stage.stages.stage_name
  method_path  = "*/*"  

  settings {
    logging_level      = "INFO"         
    data_trace_enabled = true           
    metrics_enabled    = true           
  }
}

resource "aws_iam_role" "api_role" {
  name = "roleforapi"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "apigateway_cloudwatch_policy" {
  name        = "apigateway_cloudwatch_policy"
  description = "Policy to allow API Gateway to write logs to CloudWatch"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "apigateway_policy_attachment" {
  role       = aws_iam_role.api_role.name
  policy_arn  = aws_iam_policy.apigateway_cloudwatch_policy.arn
}

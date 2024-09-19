resource "aws_lambda_function" "apilambda" {
  function_name = "mylambda"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.12"
  handler       = "mylambda.lambda_handler"
  filename      = "mylambda.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "roleforlambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# components/lambda/main.tf
resource "aws_iam_policy" "lambda_sns_policy" {
  name        = "lambda_sns_policy"
  description = "Policy to allow Lambda to publish to SNS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "sns:Publish",
        Effect   = "Allow",
        Resource = var.sns_topic_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_sns_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_sns_policy.arn
}
resource "aws_iam_policy" "lambda_cloudwatch_policy" {
  name        = "lambda_cloudwatch_policy"
  description = "Allow Lambda to write logs to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Attach the CloudWatch policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_cloudwatch_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_cloudwatch_policy.arn
  role     = aws_iam_role.lambda_role.name
}
resource "aws_cloudwatch_log_group" "cloudlog" {
  name = "/aws/lambda/your-log-group-name"
}

resource "aws_cloudwatch_log_stream" "foo" {
  log_group_name = aws_cloudwatch_log_group.cloudlog.name
  name           = "your-log-stream-name"
}
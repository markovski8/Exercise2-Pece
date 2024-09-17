resource "aws_lambda_function" "apilambda" {
  function_name = "order_lambda"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.12"
  handler       = "lambda_function.apilambda_handler"
  filename      = "lambda_order.zip"
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

resource "aws_iam_policy" "lambda_sns_policy" {
  name        = "lambda_sns_policy"
  description = "Policy to allow Lambda to publish to SNS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "sns:Publish"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:sns:eu-central-1:471112871708:ordertopic"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_sns_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_sns_policy.arn
}


# resource "aws_lambda_function" "apilambda" {
#   function_name = "order-lambda"
#   role          = aws_iam_role.lambda_exec_role.arn
#   runtime = "python3.9"
#   handler       = "lambda_function.apilambda_handler"
#   filename      = "lambda_function_payload.zip"
# }

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

# resource "aws_iam_policy" "lambda_sns_policy" {
#   name        = "lambda_sns_policy"
#   description = "Policy to allow Lambda to publish to SNS"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = [
#           "sns:Publish"
#         ],
#         Effect   = "Allow",
#         Resource = "arn:aws:sns:${var.region}:${var.account_id}:your_sns_topic_name"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "lambda_sns_policy_attach" {
#   role       = aws_iam_role.lambda_sns_role.name
#   policy_arn = aws_iam_policy.lambda_sns_policy.arn
# }
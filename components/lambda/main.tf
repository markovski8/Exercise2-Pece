resource "aws_lambda_function" "apilambda" {
  function_name = "order-lambda"
  role          = aws_iam_role.lambda_exec_role.arn
  runtime = "python 3.9"
  handler       = "lambda_function.lambda_handler"
  filename      = "lambda_function_payload.zip"
}
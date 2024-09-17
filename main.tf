module "apiGateway" {
  source = "./components/apiGateway"
}

module "lambda" {
    source = "./components/lambda"
}

module "sns" {
  source = "./components/sns"
  email = var.email
}
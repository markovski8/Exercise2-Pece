module "apiGateway" {
  source = "./components/apiGateway"
}

module "lambda" {
    source = "./components/lambda"
}

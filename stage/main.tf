provider "aws" {
  access_key = "test"
  secret_key = "test"
  region     = "us-east-1"
}

module "iam" {
  source = "../modules/iam"

  user_list1 = var.user_list1
  user_list2 = var.user_list2
}

module "apigateway_lambda" {
  source = "../modules/apigateway-lambda"
  
  visiter_role_arn = module.iam.visiter_role_arn
  secret_token_name = "secret_token" // ! temp hardcode, TODO: change with real variable
}
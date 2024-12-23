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
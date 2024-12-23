# get visiter role with policies at prod/stage
# prod/stageでポリシーを持つ訪問者ロールを取得する
variable "visiter_role_arn" {
  description = "The ARN of the visitor role"
  type        = string
}

# localstack default hostname for aws lambda to find localstack docker 
# dockerでaws lambdaがlocalstackを見つけるためのlocalstackデフォルトホスト名 
variable "localstack_hostname" {
  description = "LocalStack hostname"
  type        = string
  default     = "localhost.localstack.cloud"
}

# secret token name for secret we need
# シークレットトークン名
variable "secret_token_name" {
  description = "Secret token name"
  type        = string
}
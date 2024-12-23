data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# create zip file based on lambda.js
# lambda.jsを基にzipファイルを作成する
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda.js"
  output_path = "lambda.zip"
}

# random name
resource "random_pet" "this" {
  length = 2
}

# create API Gateway REST API based on random name
# ランダムな名前に基づいてAPI Gateway REST APIを作成する
resource "aws_api_gateway_rest_api" "this" {
  name = random_pet.this.id
}

# create API Gateway and associate parameter
# APIゲートウェイを作成し、パラメータを関連付ける
resource "aws_api_gateway_resource" "this" {
  path_part   = "secret"
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.this.id
}

# limit api Method
# API メソッドを制限する
resource "aws_api_gateway_method" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.this.id
  http_method   = "POST"
  authorization = "NONE"
}

# apigateway connect to lambda integration
# apigateway to lambda の接続方法
resource "aws_api_gateway_integration" "this" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.this.id
  http_method             = aws_api_gateway_method.this.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.this.arn}/invocations"
}

# apigateway rebuild timing and deploy setting
# apigateway タイミングとデプロイ設定
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.this.id,
      aws_api_gateway_method.this.id,
      aws_api_gateway_integration.this.id,
      "${data.archive_file.lambda.output_base64sha256}"
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# apigateway stage control dev/prod/stage ...etc
resource "aws_api_gateway_stage" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = "dev"
  deployment_id = aws_api_gateway_deployment.this.id

  variables = {
    foo = "bar"
  }
}

# get apigateway permission to use lambda function
# lambdaの使用許可を得る
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/*/*"
}

# create lambda function based on lambda.zip file and role
# lambda.zipファイルとロールに基づいてラムダ関数を作成する
resource "aws_lambda_function" "this" {
  filename      = "lambda.zip"
  function_name = random_pet.this.id
  role          = var.visiter_role_arn
  handler       = "lambda.handler"

  source_code_hash = "${data.archive_file.lambda.output_base64sha256}"

  runtime = "nodejs16.x"

  environment {
    variables = {
      AWS_REGION = "${data.aws_region.current.name}"
      LOCALSTACK_HOSTNAME = var.localstack_hostname
    }
  }
}

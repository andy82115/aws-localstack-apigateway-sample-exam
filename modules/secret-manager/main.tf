# create Secrets Manager Secret
resource "aws_secretsmanager_secret" "secret_token" {
  name        = "secret_token"
  description = "This is a secret token used by Lambda."
}

# set default secret value
resource "aws_secretsmanager_secret_version" "token_value" {
  secret_id     = aws_secretsmanager_secret.secret_token.id
  secret_string = jsonencode({ password = "initial-password" })
}
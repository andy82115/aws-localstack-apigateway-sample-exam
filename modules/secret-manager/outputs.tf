output "secret_token_name" {
  value = aws_secretsmanager_secret.secret_token.name
  description = "secret token name"
}
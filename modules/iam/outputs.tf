# output policy for other modules
# 他のモジュールへの出力ポリシー
output "visiter_role_arn" {
  value = aws_iam_role.visiter.arn
  description = "The ARN of the visitor role"
}

# output access key and secret key for level1
# level1のアクセスキーとシークレットキーを出力する。
output "level1_access_key_ids" {
  value     = { for k, v in aws_iam_access_key.level1 : k => v.id }
  sensitive = true
}

output "level1_secret_access_keys" {
  value     = { for k, v in aws_iam_access_key.level1 : k => v.secret }
  sensitive = true
}

# output access key and secret key for level2
# level2のアクセスキーとシークレットキーを出力する。
output "level2_access_key_ids" {
  value     = { for k, v in aws_iam_access_key.level2 : k => v.id }
  sensitive = true
}

output "level2_secret_access_keys" {
  value     = { for k, v in aws_iam_access_key.level2 : k => v.secret }
  sensitive = true
}

# print access key and secret key for level1 users
# level1ユーザーのアクセスキーとシークレットキーを表示する。
locals {
  level1_users_keys = join("\n", flatten([
    for key in aws_iam_access_key.level1 : "${key.user}\naccesskey:${key.id}\nsecretkey:${key.secret}\n"
  ]))
}

# print access key and secret key for level2 users
# level2ユーザーのアクセスキーとシークレットキーを表示する。
locals {
  level2_users_keys = join("\n", flatten([
    for key in aws_iam_access_key.level2 : "${key.user}\naccesskey:${key.id}\nsecretkey:${key.secret}\n"
  ]))
}

# output access key and secret key for level1 and level2 users as .md file
resource "local_file" "level1_users_keys" {
  content  = local.level1_users_keys
  filename = "level1_users_keys.md"
}

resource "local_file" "level2_users_keys" {
  content  = local.level2_users_keys
  filename = "level2_users_keys.md"
}


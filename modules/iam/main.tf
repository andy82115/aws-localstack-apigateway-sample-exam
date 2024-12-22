# create users level1
# level1ユーザーを作る 
resource "aws_iam_user" "level1" {
  for_each = toset(var.user_list1)
  name     = each.value

  tags = {
    creator = each.value
  }
}

# create users level2
# level2ユーザーを作る 
resource "aws_iam_user" "level2" {
  for_each = toset(var.user_list2)
  name     = each.value

  tags = {
    creator = each.value
  }
}

# create level1 users' keys
# level1ユーザーのアクセスキーを作る 
resource "aws_iam_access_key" "level1" {
  for_each = aws_iam_user.level1
  user     = each.value.name
}

# create level2 users' keys
# level2ユーザーのアクセスキーを作る 
resource "aws_iam_access_key" "level2" {
  for_each = aws_iam_user.level2
  user     = each.value.name
}

# create group1
# group1を作る 
resource "aws_iam_group" "terraform-developers-group1" {
  name = var.group1_name
}

# create group2
# group2を作る 
resource "aws_iam_group" "terraform-developers-group2" {
  name = var.group2_name
}

# bind users to group1
# ユーザーをgroup1にバインドする
resource "aws_iam_group_membership" "group1" {
  for_each = aws_iam_user.level1
  name     = each.value.name
  users    = [each.value.name]
  group    = aws_iam_group.terraform-developers-group1.name
}

# bind users to group2
# ユーザーをgroup2にバインドする
resource "aws_iam_group_membership" "group2" {
  for_each = aws_iam_user.level2
  name     = each.value.name
  users    = [each.value.name]
  group    = aws_iam_group.terraform-developers-group2.name
}

# bind policy to group1
# group1にポリシーをバインドする
resource "aws_iam_group_policy_attachment" "group1" {
  for_each  = toset(var.group1_policies)
  policy_arn = each.value
  group      = aws_iam_group.terraform-developers-group1.name
}

# bind policy to group2
# group2にポリシーをバインドする
resource "aws_iam_group_policy_attachment" "group2" {
  for_each  = toset(var.group2_policies)
  policy_arn = each.value
  group      = aws_iam_group.terraform-developers-group2.name
}

# ! start of roles

# create visiter role
# 訪問者ロールを作成する
resource "aws_iam_role" "visiter" {
  name = "visiter-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = ["sts:AssumeRole"]
        Principal = {
          Service = [for principal in var.visiter_role_principals : principal]
        }
        Effect   = "Allow"
        Sid      = "VisiterTempRolePolicy"
      }
    ]
  })
}

#policy of visiter role
#訪問者のポリシー
resource "aws_iam_role_policy" "visiter_lambda" {
  name   = "lambda-policy"
  role   = aws_iam_role.visiter.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue", "secretsmanager:PutSecretValue"]
      Resource = "*"
    }]
  })
}
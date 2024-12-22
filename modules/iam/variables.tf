# level1 user list. Controlled by prod or stage variable
# level1ユーザーリスト。prodまたはstageの変数によって制御される
variable "user_list1" {
  description = "List of user names for group 1"
  type        = list(string)
  default     = []
}

# level2 user list. Controlled by prod or stage variable
# level2ユーザーリスト。prodまたはstageの変数によって制御される
variable "user_list2" {
  description = "List of user names for group 2"
  type        = list(string)
  default     = []
}

# group1 name
variable "group1_name" {
  description = "Name of the first user group"
  type        = string
  default     = "terraform-developers-group1"
}

# group2 name
variable "group2_name" {
  description = "Name of the second user group"
  type        = string
  default     = "terraform-developers-group2"
}

# group1 policies by arn
variable "group1_policies" {
  description = "List of policies for group 1"
  type        = list(string)
  default     = [
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ]
}

# group2 policies by arn
variable "group2_policies" {
  description = "List of policies for group 2"
  type        = list(string)
  default     = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  ]
}

# role policies' pricipals
variable "visiter_role_principals" {
  type    = list(string)
  default = ["lambda.amazonaws.com"]
}
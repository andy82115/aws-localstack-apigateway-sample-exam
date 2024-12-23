#  users 1 -> level1
variable "user_list1" {
  description = "List of user names for group 1"
  type        = list(string)
  default     = ["level1_prod1", "level1_prod2", "level1_prod3"]
}

#  users 2 -> level2
variable "user_list2" {
  description = "List of user names for group 2"
  type        = list(string)
  default     = ["level2_prod1", "level2_prod2", "level2_prod3"]
}
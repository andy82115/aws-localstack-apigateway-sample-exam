#  users 1 -> level1
variable "user_list1" {
  description = "List of user names for group 1"
  type        = list(string)
  default     = ["level1_stage1", "level1_stage2", "level1_stage3"]
}

# users 2 -> level2
variable "user_list2" {
  description = "List of user names for group 2"
  type        = list(string)
  default     = ["level2_stage1", "level2_stage2", "level2_stage3"]
}
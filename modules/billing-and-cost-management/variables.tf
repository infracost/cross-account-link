variable "aws_account_id" {
  description = "The AWS account ID."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources created by this module."
  type        = map(string)
  default     = {}
}

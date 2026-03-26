variable "aws_organization_arn" {
  description = "The ARN of the AWS Organization for Storage Lens configuration scope."
  type        = string
}

variable "aws_trusted_principals" {
  description = "The list of trusted principals for organization wide visibility."
  type        = list(string)
}

variable "aws_account_id" {
  description = "The AWS account ID for the Storage Lens configuration."
  type        = string
}

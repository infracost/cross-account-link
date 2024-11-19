variable "infracost_external_id" {
  description = "Your Infracost Organization ID (get it from Org Settings under Settings in the https://dashboard.infracost.io)"
  type        = string
}

variable "infracost_account" {
  description = "The Infracost account ID which has permission to your account."
  type        = string
  default     = "237144093413"
}

variable "include_cloudwatch_readonly_policy" {
  description = "Whether to include the CloudWatch read-only policy in the Cross-Account Role."
  type        = bool
  default     = true
}

variable "include_services_readonly_policy" {
  description = "Whether to include the services read-only policy in the Cross-Account Role."
  type        = bool
  default     = true
}

variable "infracost_external_id" {
  description = "Your Infracost Organization ID (get it from Org Settings under Settings in the https://dashboard.infracost.io)"
  type        = string
}

variable "infracost_account" {
  description = "The Infracost account ID which has permission to your account. Do not change this."
  type        = string
  default     = "237144093413"
}

variable "is_management_account" {
  description = "Whether this is the management account. If true, this sets up access to recommendations, cost, usage and pricing data. Otherwise, this sets up read-only access to a limited set of resources."
  type        = bool
  default     = false
}

variable "role_suffix" {
  description = "The suffix for the role name. This can be used if you need to create multiple roles in the same account for testing purposes."
  type        = string
  default     = ""
}

variable "storage_lens_bucket_arns" {
  description = "List of S3 bucket ARNs to grant read access to for Storage Lens data. Only applies to the management account."
  type        = list(string)
  default     = []
}

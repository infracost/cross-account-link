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

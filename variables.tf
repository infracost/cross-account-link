variable "infracost_external_id" {
  description = "Your Infracost Organization ID (get it from Org Settings under Settings in the https://dashboard.infracost.io)"
  type        = string
}

variable "infracost_account" {
  description = "The Infracost account ID which has permission to your account."
  type        = string
  default     = "237144093413"
}

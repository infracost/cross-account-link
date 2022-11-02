variable "infracost_external_id" {
  description = "Your Infracost Organization ID (get it from Org Settings in https://dashboard.infracost.io)"
  type        = string
}


variable "infracost_account" {
  description = "The Infracost account ID which has permission to your account."
  type        = string
  default     = "237144093413"
}

variable "infracost_notification_topic_arn" {
  description = "The topic the S3 bucket will notify when a new report is uploaded."
  type        = string
  default     = "arn:aws:sns:us-east-1:237144093413:cur-uploaded"
}


output "role_arn" {
  description = "The ARN value of the Cross-Account Role with IAM read-only permissions. Provide this to Infracost."
  value       = aws_iam_role.cross_account_role.arn
}


output "bucket_arn" {
  description = "The ARN value of the bucket where the CUR will be stored. Provide this to Infracost."
  value       = aws_s3_bucket.cost_and_usage_report_bucket.arn
}

output "role_arn" {
  description = "The ARN value of the Cross-Account Role with IAM read-only permissions. Provide this to Infracost."
  value       = aws_iam_role.cross_account_role.arn
}

resource "aws_iam_policy" "storage_lens_s3_readonly_policy" {
  count       = var.is_management_account && length(var.storage_lens_bucket_arns) > 0 ? 1 : 0
  name        = "infracost-storage-lens-s3-readonly${var.role_suffix}"
  path        = "/"
  description = "Infracost Storage Lens S3 read-only policy"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "InfracostStorageLensS3BucketAccess"
        Effect : "Allow"
        Action : [
          "s3:ListBucket",
        ]
        Resource : var.storage_lens_bucket_arns
      },
      {
        Sid : "InfracostStorageLensS3ObjectAccess"
        Effect : "Allow"
        Action : [
          "s3:GetObject",
          "s3:HeadObject",
        ]
        Resource : [for arn in var.storage_lens_bucket_arns : "${arn}/*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "storage_lens_s3_readonly_policy_attachment" {
  count      = var.is_management_account && length(var.storage_lens_bucket_arns) > 0 ? 1 : 0
  policy_arn = aws_iam_policy.storage_lens_s3_readonly_policy[count.index].arn
  role       = aws_iam_role.cross_account_role.name
}

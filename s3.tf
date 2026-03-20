resource "aws_iam_policy" "s3_access_policy" {
  count       = length(var.s3_bucket_arns) > 0 ? 1 : 0
  name        = "infracost-s3-access${var.role_suffix}"
  path        = "/"
  description = "Infracost S3 read-only policy"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "InfracostS3BucketAccess"
        Effect : "Allow"
        Action : [
          "s3:GetBucketLocation",
          "s3:ListBucket",
        ]
        Resource : var.s3_bucket_arns
      },
      {
        Sid : "InfracostS3ObjectAccess"
        Effect : "Allow"
        Action : [
          "s3:GetObject",
          "s3:HeadObject",
        ]
        Resource : [for arn in var.s3_bucket_arns : "${arn}/*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_access_policy_attachment" {
  count      = length(var.s3_bucket_arns) > 0 ? 1 : 0
  policy_arn = aws_iam_policy.s3_access_policy[count.index].arn
  role       = aws_iam_role.cross_account_role.name
}

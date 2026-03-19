resource "aws_iam_policy" "s3_access_policy" {
  count       = length(var.s3_bucket_arns) > 0 ? 1 : 0
  name        = "infracost-s3-access${var.role_suffix}"
  path        = "/"
  description = "Infracost S3 access policy"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "InfracostS3FullAccess"
        Effect : "Allow"
        Action : "s3:*"
        Resource : flatten([
          var.s3_bucket_arns,
          [for arn in var.s3_bucket_arns : "${arn}/*"]
        ])
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_access_policy_attachment" {
  count      = length(var.s3_bucket_arns) > 0 ? 1 : 0
  policy_arn = aws_iam_policy.s3_access_policy[count.index].arn
  role       = aws_iam_role.cross_account_role.name
}

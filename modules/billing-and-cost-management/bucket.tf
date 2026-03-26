resource "aws_s3_bucket" "bcm_data_exports" {
  bucket = "infracost-bcm-exports-${var.aws_account_id}"
}

resource "aws_s3_bucket_lifecycle_configuration" "data_exports_lifecycle" {
  bucket = aws_s3_bucket.bcm_data_exports.id

  rule {
    id     = "intelligent-tiering"
    status = "Enabled"

    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }

    expiration {
      days = 365
    }
  }
}

data "aws_iam_policy_document" "data_exports_policy_doc" {
  statement {
    sid    = "AllowBCMDataExportsWrite"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "bcm-data-exports.amazonaws.com",
        "billingreports.amazonaws.com",
      ]
    }

    actions = [
      "s3:GetBucketPolicy",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.bcm_data_exports.arn,
      "${aws_s3_bucket.bcm_data_exports.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values = [
        var.aws_account_id,
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "data_exports_policy" {
  bucket = aws_s3_bucket.bcm_data_exports.id
  policy = data.aws_iam_policy_document.data_exports_policy_doc.json
}

resource "aws_s3_bucket" "storage_lens_data_exports" {
  bucket = "infracost-storagelens-exports-${var.aws_account_id}"
}

resource "aws_s3_bucket_lifecycle_configuration" "data_exports_lifecycle" {
  bucket = aws_s3_bucket.storage_lens_data_exports.id

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
    sid    = "AllowStorageLensDataExportsWrite"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "storage-lens.s3.amazonaws.com",
      ]
    }

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    resources = [
      aws_s3_bucket.storage_lens_data_exports.arn,
      "${aws_s3_bucket.storage_lens_data_exports.arn}/*",
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
  bucket = aws_s3_bucket.storage_lens_data_exports.id
  policy = data.aws_iam_policy_document.data_exports_policy_doc.json
}

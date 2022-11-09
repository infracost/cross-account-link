terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [ aws.us_east_1 ]
    }
  }
}

resource "aws_iam_role" "cross_account_role" {
  assume_role_policy = jsonencode({
    Statement = [
      {
        Effect : "Allow", Principal : { AWS : "arn:aws:iam::${var.infracost_account}:root" }, Action : "sts:AssumeRole",
        Condition : { StringEquals : { "sts:ExternalId" : var.infracost_external_id } }
      }
    ]
  })

  path                = "/"

  inline_policy {
    name   = "root"
    policy = jsonencode({
      Version : "2012-10-17", Statement : [
        {
          Action : [
            "aws-portal:View*",
            "budgets:Describe*",
            "budgets:View*",
            "ce:Get*",
            "ce:Describe*",
            "ce:List*",
            "cur:Describe*",
            "pricing:*",
            "organizations:Describe*",
            "organizations:List*",
            "savingsplans:Describe*"
          ], Resource : "*", Effect : "Allow", Sid : "InfracostBillingReadOnly"
        }
      ]
    })
  }

  inline_policy {
    name   = "InfracostCloudWatchMetricsReadOnly"
    policy = jsonencode({
      Version : "2012-10-17", Statement : [
        {
          Action : ["logs:List*", "logs:Describe*", "logs:StartQuery", "logs:StopQuery", "logs:Filter*", "logs:Get*"],
          Resource : "arn:aws:logs:*:*:log-group:/aws/containerinsights/*", Effect : "Allow",
          Sid : "InfracostContainerInsightsReadOnly"
        }, {
          Action : ["logs:GetQueryResults", "logs:DescribeLogGroups"],
          Resource : "arn:aws:logs:*:*:log-group::log-stream:*", Effect : "Allow",
          Sid : "InfracostContainerInsightsLogStream"
        }, {
          Action : ["autoscaling:Describe*", "cloudwatch:Describe*", "cloudwatch:Get*", "cloudwatch:List*"],
          Resource : "*", Effect : "Allow", Sid : "InfracostContainerMetricsAccess"
        }
      ]
    })
  }

  inline_policy {
    name   = "InfracostAdditionalResourceReadOnly"
    policy = jsonencode({
      Version : "2012-10-17", Statement : [
        {
          Effect : "Allow", Resource : "*", Action : [
          "a4b:List*",
          "a4b:Search*",
          "acm:Describe*",
          "acm:List*",
          "acm-pca:Describe*",
          "acm-pca:List*",
          "amplify:ListApps",
          "amplify:ListBranches",
          "amplify:ListDomainAssociations",
          "amplify:ListJobs",
          "application-autoscaling:Describe*",
          "applicationinsights:Describe*",
          "applicationinsights:List*",
          "appmesh:Describe*",
          "appmesh:List*",
          "appstream:Describe*",
          "appstream:List*",
          "appsync:List*",
          "autoscaling-plans:Describe*",
          "athena:Batch*",
          "aws-portal:View*",
          "backup:Describe*",
          "backup:List*",
          "batch:List*",
          "batch:Describe*",
          "budgets:Describe*",
          "budgets:View*",
          "ce:Get*",
          "chatbot:Describe*",
          "chime:List*",
          "chime:Retrieve*",
          "chime:Search*",
          "chime:Validate*",
          "cloud9:Describe*",
          "cloud9:List*",
          "clouddirectory:List*",
          "cloudformation:Describe*",
          "cloudhsm:List*",
          "cloudhsm:Describe*",
          "cloudsearch:Describe*",
          "cloudtrail:Describe*",
          "cloudtrail:Get*",
          "cloudtrail:List*",
          "cloudwatch:Describe*",
          "codeartifact:DescribeDomain",
          "codeartifact:DescribePackageVersion",
          "codeartifact:DescribeRepository",
          "codeartifact:ListDomains",
          "codeartifact:ListPackages",
          "codeartifact:ListPackageVersionAssets",
          "codeartifact:ListPackageVersionDependencies",
          "codeartifact:ListPackageVersions",
          "codeartifact:ListRepositories",
          "codeartifact:ListRepositoriesInDomain",
          "codebuild:DescribeCodeCoverages",
          "codebuild:DescribeTestCases",
          "codebuild:Get*",
          "codebuild:List*",
          "codebuild:BatchGetBuilds",
          "codebuild:BatchGetProjects",
          "codecommit:Describe*",
          "codeguru-profiler:Describe*",
          "codeguru-profiler:List*",
          "codeguru-reviewer:Describe*",
          "codeguru-reviewer:List*",
          "codepipeline:List*",
          "codepipeline:Get*",
          "codestar:Describe*",
          "config:Deliver*",
          "connect:Describe*",
          "dataexchange:List*",
          "datasync:Describe*",
          "datasync:List*",
          "datapipeline:Describe*",
          "datapipeline:List*",
          "detective:List*",
          "discovery:Describe*",
          "dms:Describe*",
          "dms:Test*",
          "ds:Check*",
          "ds:Describe*",
          "ds:List*",
          "ds:Verify*",
          "dynamodb:Describe*",
          "dynamodb:List*",
          "ec2:Describe*",
          "ec2:GetCapacityReservationUsage",
          "ec2:GetEbsEncryptionByDefault",
          "ec2:SearchTransitGatewayRoutes",
          "ecr:BatchCheck*",
          "ecr:BatchGet*",
          "ecr:Describe*",
          "ecr:List*",
          "eks:DescribeCluster",
          "eks:DescribeUpdate",
          "eks:Describe*",
          "eks:ListClusters",
          "eks:ListUpdates",
          "eks:List*",
          "elasticache:List*",
          "elasticbeanstalk:Check*",
          "elasticbeanstalk:Describe*",
          "elasticbeanstalk:List*",
          "elasticbeanstalk:Request*",
          "elasticbeanstalk:Retrieve*",
          "elasticbeanstalk:Validate*",
          "elasticfilesystem:Describe*",
          "elasticloadbalancing:Describe*",
          "elasticmapreduce:Describe*",
          "elasticmapreduce:View*",
          "elastictranscoder:Read*",
          "elemental-appliances-software:List*",
          "es:Describe*",
          "es:List*",
          "es:ESHttpHead",
          "events:Describe*",
          "events:List*",
          "events:Test*",
          "firehose:Describe*",
          "fsx:Describe*",
          "fsx:List*",
          "freertos:Describe*",
          "freertos:List*",
          "glacier:Describe*",
          "globalaccelerator:Describe*",
          "globalaccelerator:List*",
          "glue:ListCrawlers",
          "glue:ListDevEndpoints",
          "glue:ListJobs",
          "glue:ListMLTransforms",
          "glue:ListTriggers",
          "glue:ListWorkflows",
          "guardduty:List*",
          "health:Describe*",
          "iam:Get*",
          "imagebuilder:List*",
          "importexport:List*",
          "inspector:Describe*",
          "inspector:Preview*",
          "iot:Describe*",
          "iotanalytics:Describe*",
          "iotanalytics:List*",
          "iotsitewise:Describe*",
          "iotsitewise:List*",
          "kafka:Describe*",
          "kafka:List*",
          "kinesisanalytics:Describe*",
          "kinesisanalytics:Discover*",
          "kinesisanalytics:List*",
          "kinesisvideo:Describe*",
          "kinesisvideo:List*",
          "kinesis:Describe*",
          "kinesis:List*",
          "kms:Describe*",
          "kms:List*",
          "license-manager:List*",
          "logs:ListTagsLogGroup",
          "logs:TestMetricFilter",
          "mediaconvert:DescribeEndpoints",
          "mediaconvert:List*",
          "mediapackage:List*",
          "mediapackage:Describe*",
          "medialive:List*",
          "medialive:Describe*",
          "mediaconnect:List*",
          "mediaconnect:Describe*",
          "mediapackage-vod:List*",
          "mediapackage-vod:Describe*",
          "mediastore:List*",
          "mediastore:Describe*",
          "mediatailor:List*",
          "mediatailor:Describe*",
          "mgh:Describe*",
          "mgh:List*",
          "mobilehub:Describe*",
          "mobilehub:List*",
          "mobiletargeting:List*",
          "mq:Describe*",
          "mq:List*",
          "opsworks-cm:List*",
          "organizations:Describe*",
          "outposts:List*",
          "personalize:Describe*",
          "personalize:List*",
          "pi:DescribeDimensionKeys",
          "polly:SynthesizeSpeech",
          "qldb:ListLedgers",
          "qldb:ListTagsForResource",
          "ram:List*",
          "rekognition:List*",
          "rds:List*",
          "redshift:Describe*",
          "redshift:View*",
          "resource-groups:Get*",
          "resource-groups:List*",
          "resource-groups:Search*",
          "robomaker:BatchDescribe*",
          "robomaker:Describe*",
          "robomaker:List*",
          "route53domains:Check*",
          "route53domains:Get*",
          "route53domains:View*",
          "s3:List*",
          "s3:GetBucketLocation",
          "s3:GetBucketTagging",
          "schemas:Describe*",
          "schemas:List*",
          "sdb:Select*",
          "secretsmanager:List*",
          "secretsmanager:Describe*",
          "securityhub:Describe*",
          "securityhub:List*",
          "serverlessrepo:List*",
          "servicecatalog:Scan*",
          "servicecatalog:Search*",
          "servicecatalog:Describe*",
          "servicediscovery:Get*",
          "servicediscovery:List*",
          "ses:Describe*",
          "shield:Describe*",
          "snowball:Describe*",
          "snowball:List*",
          "sns:Check*",
          "sqs:List*",
          "ssm:Describe*",
          "ssm:List*",
          "sso:Describe*",
          "sso:List*",
          "sso:Search*",
          "sso-directory:Describe*",
          "sso-directory:List*",
          "sso-directory:Search*",
          "states:List*",
          "states:Describe*",
          "storagegateway:Describe*",
          "storagegateway:List*",
          "sts:GetCallerIdentity",
          "sts:GetSessionToken",
          "swf:Describe*",
          "synthetics:Describe*",
          "synthetics:List*",
          "tag:Get*",
          "transfer:Describe*",
          "transfer:List*",
          "transcribe:List*",
          "wafv2:Describe*",
          "worklink:Describe*",
          "worklink:List*"
        ]
        }
      ]
    })
  }
}

resource "aws_iam_policy_attachment" "cross_account_view_only" {
  name       = "infracost-cross-account-view-only"
  roles      = [aws_iam_role.cross_account_role.name]
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}

resource "aws_s3_bucket" "cost_and_usage_report_bucket" {
  acl    = "private"
  bucket = join("-", ["infracost-cur", var.infracost_external_id])
}

resource "aws_s3_bucket_lifecycle_configuration" "cost_and_usage_report_bucket" {
  bucket = aws_s3_bucket.cost_and_usage_report_bucket.id

  rule {
    id     = "ExpireOldObjects"
    status = "Enabled"

    expiration {
      days = 200
    }
  }
}

data "aws_region" "current" {}

resource "aws_s3_bucket_notification" "sns_topic" {
  bucket = aws_s3_bucket.cost_and_usage_report_bucket.id

  topic {
    topic_arn = "arn:aws:sns:${data.aws_region.current.name}:${var.infracost_account}:cur-uploaded"

    events = [
      "s3:ObjectCreated:*",
    ]

    filter_suffix = "Manifest.json"
  }
}

resource "aws_s3_bucket_public_access_block" "cost_and_usage_report_bucket" {
  bucket = aws_s3_bucket.cost_and_usage_report_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "cost_and_usage_report_bucket_policy" {
  bucket = aws_s3_bucket.cost_and_usage_report_bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "billingreports.amazonaws.com"
        },
        "Action" : [
          "s3:GetBucketAcl",
          "s3:GetBucketPolicy"
        ],
        "Resource" : "arn:aws:s3:::${aws_s3_bucket.cost_and_usage_report_bucket.id}"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "billingreports.amazonaws.com"
        },
        "Action" : "s3:PutObject",
        "Resource" : "arn:aws:s3:::${aws_s3_bucket.cost_and_usage_report_bucket.id}/*"
      },
      {
        Action : [
          "s3:GetObject",
          "s3:GetObjectAcl"
        ],
        Effect : "Allow",
        Resource : "arn:aws:s3:::${aws_s3_bucket.cost_and_usage_report_bucket.id}/*",
        Principal : {
          AWS : aws_iam_role.cross_account_role.arn
        }
      }
    ]
  })
}

resource "aws_cur_report_definition" "costand_usage_report" {
  provider = aws.us_east_1

  additional_artifacts       = []
  additional_schema_elements = ["RESOURCES"]
  compression                = "GZIP"
  format                     = "textORcsv"
  refresh_closed_reports     = true
  report_name                = join("", ["InfracostReport", var.infracost_external_id])
  report_versioning          = "OVERWRITE_REPORT"
  s3_bucket                  = aws_s3_bucket.cost_and_usage_report_bucket.id
  s3_prefix                  = "daily-v1"
  s3_region                  = aws_s3_bucket.cost_and_usage_report_bucket.region
  time_unit                  = "DAILY"

  depends_on = [
    aws_s3_bucket_policy.cost_and_usage_report_bucket_policy
  ]
}


resource "aws_iam_policy" "object_get_iam_policy" {
  name   = "ObjectGetCostandUsageReports"
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect : "Allow", Action : ["s3:GetObject", "s3:GetObjectAcl"],
        Resource : ["arn:aws:s3:::${aws_s3_bucket.cost_and_usage_report_bucket.id}/*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "object_get_iam_policy_attach" {
  role       = aws_iam_role.cross_account_role.name
  policy_arn = aws_iam_policy.object_get_iam_policy.arn
}

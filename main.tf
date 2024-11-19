terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws]
    }
  }
}

resource "aws_iam_policy" "infracost_cost_readonly_policy" {
  name        = "infracost-cost-readonly"
  path        = "/"
  description = "Infracost cost exploration read-only policy"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : [
          "aws-portal:View*",
          "budgets:Describe*",
          "budgets:View*",
          "ce:Get*",
          "ce:Describe*",
          "ce:List*",
          "cost-optimization-hub:List*",
          "cost-optimization-hub:Get*",
          "compute-optimizer:Export*",
          "compute-optimizer:Get*",
          "ec2:Describe*",
          "ec2:Get*",
          "ec2:List*",
          "ecs:Describe*",
          "ecs:List*",
          "eks:Describe*",
          "eks:List*",
          "autoscaling:Describe*",
          "autoscaling-plans:Describe*",
          "rds:Describe*",
          "rds:Get*",
          "rds:List*",
          "trustedadvisor:Describe*",
          "trustedadvisor:Get*",
          "trustedadvisor:List*",
          "cur:Describe*",
          "pricing:*",
          "organizations:Describe*",
          "organizations:List*",
          "savingsplans:Describe*"
        ],
        Resource : "*",
        Effect : "Allow",
        Sid : "InfracostBillingReadOnly"
      }
    ]
  })
}

resource "aws_iam_policy" "infracost_cloudwatch_readonly_policy" {

  count = var.include_cloudwatch_readonly_policy ? 1 : 0

  name        = "infracost-cloudwatch-readonly"
  path        = "/"
  description = "Infracost CloudWatch read-only policy"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "InfracostContainerInsightsReadOnly",
        Effect : "Allow",
        Action : ["logs:List*", "logs:Describe*", "logs:StartQuery", "logs:StopQuery", "logs:Filter*", "logs:Get*"],
        Resource : "arn:aws:logs:*:*:log-group:/aws/containerinsights/*",
      },
      {
        Sid : "InfracostContainerInsightsLogStream",
        Effect : "Allow",
        Action : ["logs:GetQueryResults", "logs:DescribeLogGroups"],
        Resource : "arn:aws:logs:*:*:log-group::log-stream:*"
      },
      {
        Sid : "InfracostContainerMetricsAccess"
        Effect : "Allow",
        Action : ["autoscaling:Describe*", "cloudwatch:Describe*", "cloudwatch:Get*", "cloudwatch:List*"],
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "infracost_services_readonly_policy" {

  count = var.include_services_readonly_policy ? 1 : 0

  name        = "infracost-services-readonly"
  path        = "/"
  description = "Infracost service read-only policy"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Resource : "*",
        Action : [
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

resource "aws_iam_role" "cross_account_role" {
  name = "infracost-readonly"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement = [
      {
        Effect : "Allow", Principal : { AWS : "arn:aws:iam::${var.infracost_account}:root" }, Action : "sts:AssumeRole",
        Condition : { StringEquals : { "sts:ExternalId" : var.infracost_external_id } }
      }
    ]
  })
}


# Attach policies to the role
resource "aws_iam_role_policy_attachment" "infracost_cost_policy_attachment" {
  policy_arn = aws_iam_policy.infracost_cost_readonly_policy.arn
  role       = aws_iam_role.cross_account_role.name
}

resource "aws_iam_role_policy_attachment" "infracost_cloudwatch_readonly_attachment" {
  count = var.include_cloudwatch_readonly_policy ? 1 : 0

  policy_arn = aws_iam_policy.infracost_cloudwatch_readonly_policy[count.index].arn
  role       = aws_iam_role.cross_account_role.name
}

resource "aws_iam_role_policy_attachment" "infracost_services_readonly_policy_attachment" {
  count = var.include_services_readonly_policy ? 1 : 0

  policy_arn = aws_iam_policy.infracost_services_readonly_policy[count.index].arn
  role       = aws_iam_role.cross_account_role.name
}


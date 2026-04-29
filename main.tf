terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws]
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_organizations_organization" "current" {}

resource "aws_iam_role" "cross_account_role" {
  name = "infracost-readonly${var.role_suffix}"
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

resource "aws_iam_policy" "management_account_readonly_policy" {
  count       = var.is_management_account ? 1 : 0
  name        = "infracost-management-account-readonly${var.role_suffix}"
  path        = "/"
  description = "Infracost management account read-only policy"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : [
          "amplify:ListApps",
          "amplify:ListTagsForResource",
          "apigateway:GET",
          "apprunner:ListServices",
          "apprunner:ListTagsForResource",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "bcm-data-exports:Get*",
          "bcm-data-exports:List*",
          "bcm-pricing-calculator:*",
          "bedrock:ListTagsForResource",
          "ce:Describe*",
          "ce:Get*",
          "ce:List*",
          "cloudformation:DescribeStacks",
          "cloudformation:ListStacks",
          "compute-optimizer:Get*",
          "cost-optimization-hub:Get*",
          "cost-optimization-hub:List*",
          "ec2:DescribeInstances",
          "ec2:DescribeVolumes",
          "ecs:ListClusters",
          "ecs:ListServices",
          "iam:ListInstanceProfiles",
          "iam:ListInstanceProfileTags",
          "lambda:ListFunctions",
          "lambda:ListProvisionedConcurrencyConfigs",
          "logs:DescribeLogGroups",
          "logs:ListTagsLogGroup",
          "macie2:ListTagsForResource",
          "organizations:DescribeOrganization",
          "organizations:ListAccounts",
          "organizations:ListAWSServiceAccessForOrganization",
          "organizations:ListTagsForResource",
          "pricing:Describe*",
          "pricing:Get*",
          "pricing:List*",
          "rds:DescribeDBClusters",
          "rds:DescribeDBInstances",
          "s3:GetBucketLocation",
          "s3:GetBucketTagging",
          "s3:GetStorageLensConfiguration",
          "s3:GetStorageLensConfigurationTagging",
          "s3:GetStorageLensDashboard",
          "s3:ListAllMyBuckets",
          "s3:ListStorageLensConfigurations",
          "sagemaker:ListTags",
          "tag:GetResources",
          "trustedadvisor:Describe*",
          "trustedadvisor:Get*",
          "trustedadvisor:List*",
        ],
        Resource : "*",
        Effect : "Allow",
        Sid : "InfracostManagementAccountReadOnly"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "management_account_readonly_policy_attachment" {
  count      = var.is_management_account ? 1 : 0
  policy_arn = aws_iam_policy.management_account_readonly_policy[count.index].arn
  role       = aws_iam_role.cross_account_role.name
}

resource "aws_iam_policy" "member_account_readonly_policy" {
  count       = var.is_management_account ? 0 : 1
  name        = "infracost-member-account-readonly${var.role_suffix}"
  path        = "/"
  description = "Infracost member account read-only policy"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : [
          "amplify:ListApps",
          "amplify:ListTagsForResource",
          "apigateway:GET",
          "apprunner:ListServices",
          "apprunner:ListTagsForResource",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "bedrock:ListTagsForResource",
          "cloudformation:DescribeStacks",
          "cloudformation:ListStacks",
          "ec2:DescribeInstances",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeVolumes",
          "ecs:DescribeClusters",
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:ListClusters",
          "ecs:ListServices",
          "ecs:ListTaskDefinitions",
          "eks:DescribeCluster",
          "eks:DescribeNodegroup",
          "eks:ListClusters",
          "eks:ListNodegroups",
          "iam:ListInstanceProfiles",
          "iam:ListInstanceProfileTags",
          "lambda:ListFunctions",
          "lambda:ListProvisionedConcurrencyConfigs",
          "logs:DescribeLogGroups",
          "logs:ListTagsLogGroup",
          "macie2:ListTagsForResource",
          "rds:DescribeDBClusters",
          "rds:DescribeDBInstances",
          "s3:GetBucketLocation",
          "s3:GetBucketTagging",
          "s3:ListAllMyBuckets",
          "sagemaker:ListTags",
          "tag:GetResources",
        ],
        Resource : "*",
        Effect : "Allow",
        Sid : "InfracostMemberAccountReadOnly"
      }
    ]
  })
}

# Attach policies to the role
resource "aws_iam_role_policy_attachment" "member_account_readonly_policy_attachment" {
  count      = var.is_management_account ? 0 : 1
  policy_arn = aws_iam_policy.member_account_readonly_policy[count.index].arn
  role       = aws_iam_role.cross_account_role.name
}

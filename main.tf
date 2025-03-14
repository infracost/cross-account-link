terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws]
    }
  }
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

resource "aws_iam_policy" "management_account_readonly_policy" {
  count       = var.is_management_account ? 1 : 0
  name        = "infracost-management-account-readonly"
  path        = "/"
  description = "Infracost management account read-only policy"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : [
          // For getting the account names and tags
          "organizations:ListAccounts",
          "organizations:ListTagsForResource",
          // For getting recommendations
          "compute-optimizer:Get*",
          "cost-optimization-hub:List*",
          "cost-optimization-hub:Get*",
          "trustedadvisor:Describe*",
          "trustedadvisor:Get*",
          "trustedadvisor:List*",
          // For getting cost, usage and pricing data
          "ce:Get*",
          "ce:Describe*",
          "ce:List*",
          "pricing:Get*",
          "pricing:List*",
          "pricing:Describe*",
          "bcm-pricing-calculator:*"
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
  name        = "infracost-member-account-readonly"
  path        = "/"
  description = "Infracost member account read-only policy"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : [
          "ec2:DescribeInstances",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeVolumes",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeAutoScalingGroups",
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters",
          "eks:ListClusters",
          "eks:DescribeCluster",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup",
          "ecs:ListClusters",
          "ecs:DescribeClusters",
          "ecs:ListServices",
          "ecs:DescribeServices",
          "ecs:ListTaskDefinitions",
          "ecs:DescribeTaskDefinition",
          "lambda:ListFunctions"
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

terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws]
    }
  }
}

resource "aws_iam_policy" "infracost_readonly_policy" {
  name        = "infracost-readonly"
  path        = "/"
  description = "Infracost read-only policy"

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
          "lambda:ListFunctions",
          "organizations:DescribeAccount",
          "organizations:DescribeOrganization",
          "organizations:DescribeOrganizationalUnit",
          "organizations:ListAccounts",
          "organizations:ListAccountsForParent",
          "organizations:ListChildren",
          "organizations:ListParents",
          "organizations:ListRoots",
          "organizations:ListTagsForResource",
          "budgets:Describe*",
          "budgets:View*",
          "ce:Get*",
          "ce:Describe*",
          "ce:List*",
          "cost-optimization-hub:List*",
          "cost-optimization-hub:Get*",
          "compute-optimizer:Get*",
          "trustedadvisor:Describe*",
          "trustedadvisor:Get*",
          "trustedadvisor:List*",
          "pricing:Get*",
          "pricing:List*",
          "pricing:Describe*",
          "bcm-pricing-calculator:*"
        ],
        Resource : "*",
        Effect : "Allow",
        Sid : "InfracostReadOnly"
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
resource "aws_iam_role_policy_attachment" "infracost_policy_attachment" {
  policy_arn = aws_iam_policy.infracost_readonly_policy.arn
  role       = aws_iam_role.cross_account_role.name
}

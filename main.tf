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
          "compute-optimizer:GetRDSDatabaseRecommendations",
          "compute-optimizer:GetEC2InstanceRecommendations",
          "compute-optimizer:GetEBSVolumeRecommendations",
          "compute-optimizer:GetAutoScalingGroupRecommendations",
          "compute-optimizer:GetECSServiceRecommendations",
          "compute-optimizer:GetLambdaFunctionRecommendations",
          "compute-optimizer:GetRecommendationSummaries",
          "cost-optimization-hub:ListRecommendations",
        ],
        Resource : "*",
        Effect : "Allow",
        Sid : "InfracostBillingReadOnly"
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

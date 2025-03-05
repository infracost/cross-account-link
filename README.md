# Infracost AWS Read Only Role

A Terraform module to set up an AWS cross-account link for Infracost Cloud; this is required to enable in PR recommendations for in cloud optimizations.

## Scope

It is important to ensure that you have reviewed the permissions that this module will create in your AWS account. This module will create an IAM role in your AWS account that will allow Infracost to read compute optimization, trusted advisor and your AWS Cost Explorer data.

This role will also have read-only access to services within your AWS account and a subset of CloudWatch metrics.

## How to use

Import the module into your codebase and provide the `infracost_external_id` variable which points to your Infracost Cloud organization ID.

```terraform
provider "aws" {
  region = "us-west-2"
}

module "infracost" {
  source                = "github.com/infracost/cross-account-link"
  infracost_external_id = "INFRACOST_ORGANIZATION_ID"

  providers = {
    aws = aws
  }
}

output "infracost_cross_account_role_arn" {
  value = module.infracost.role_arn
}
```

Once you've run this module in your infrastructure you'll need to email Infracost with the following information:

```text
To: support@infracost.io
Subject: Enable AWS read-only access for Infracost Cloud

Body:
Hi, my name is Rafa and I'm the DevOps Lead at ACME Corporation.
Please enable the AWS actual costs feature for our organization:

- Infracost Cloud org ID: $YOUR_INFRACOST_ORGANIZATION_ID
- Our AWS Cross Account ARN: <terraform output infracost_cross_account_role_arn>

Regards,
Rafa
```

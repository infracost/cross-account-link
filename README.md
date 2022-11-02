# Infracost AWS Cross Account Linking module 

A Terraform module to set up an AWS cross-account link for Infracost Cloud. This is required to enable [Actual Costs](https://www.infracost.io/docs/infracost_cloud/actual_costs/) in Infracost Cloud.

## How to use

Import the module into your codebase and provide the `infracost_external_id` variable which points to your Infracost Cloud organization ID.

```terraform
provider "aws" {
  region  = "us-east-1" # NOTE: this can currently be us-east-1 or eu-central-1. Email hello@infracost.io if you need another region as we need to deploy our SNS topic there first.
}

module "infracost" {
  source = "github.com/infracost/cross-account-link"
  infracost_external_id = "INFRACOST_ORGANIZATION_ID"
}

output "infracost_cross_account_role_arn" {
  value = module.infracost.role_arn
}

output "infracost_cur_bucket_arn" {
  value = module.infracost.bucket_arn
}
```

Once you've run this module in your infrastructure you'll need to email Infracost with the following information:

```text
To: hello@infracost.io
Subject: Enable AWS actual costs

Body:
Hi, my name is Rafa and I'm the DevOps Lead at ACME Corporation.
Please enable the AWS actual costs feature for our organization:

- Infracost Cloud org ID: $YOUR_INFRACOST_ORGANIZATION_ID
- Our AWS Cross Account ARN: <terraform output infracost_cross_account_role_arn>
- Our AWS CUR S3 Bucket ARN: <terraform output infracost_cur_bucket_arn>

Regards,
Rafa
```

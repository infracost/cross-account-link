# Infracost AWS Read-Only Role

A Terraform module to set up an AWS cross-account link for Infracost Cloud. This gives Infracost read-only access to AWS APIs to fetch recommendations from AWS Compute Optimizer. This needs to be run against **all AWS accounts** that have recommendations as Infracost also requires details of the resources that the recommendations apply to. See the [main.tf](main.tf) file for the required permissions. 

## Prerequisites
- You have an AWS account
- You need your Infracost Cloud organization ID - find this in the Org Settings of [Infracost Cloud](https://dashboard.infracost.io)

## Usage instructions

1. Use the module to create the cross account role in all AWS accounts that have recommendations. Pass the `infracost_external_id` variable (which points to your Infracost organization ID) to the module.

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

2. Run `terraform init` and `terraform apply` to create the cross account role in all AWS accounts.

3. Email the `infracost_cross_account_role_arn` outputs to Infracost:

```text
To: support@infracost.io
Subject: Enable AWS read-only access for Infracost Cloud

Body:
Hi, my name is Rafa and I'm the DevOps Lead at ACME Corporation.

- Infracost Cloud org ID: $YOUR_INFRACOST_ORGANIZATION_ID
- Our AWS Cross Account ARNs are:
<terraform output infracost_cross_account_role_arn>

Regards,
Rafa
```

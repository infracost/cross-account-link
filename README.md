# Infracost AWS Read-Only Role

A Terraform module to set up an AWS cross-account link for Infracost Cloud. This gives Infracost read-only access to AWS APIs to fetch recommendations from AWS Compute Optimizer. This needs to be run against your AWS management account to enable access to recommendations, cost, usage and pricing data, as well as all member accounts to enable read-only access to a limited set of resources that can be used to augment the recommendations with additional context.

## Prerequisites
- You have an AWS account
- You need your Infracost Cloud organization ID - find this in the Org Settings of [Infracost Cloud](https://dashboard.infracost.io)

## Usage instructions

1. Use the module with `is_management_account = true` to create the cross account role on your management account. Pass the `infracost_external_id` variable (which points to your Infracost organization ID) to the module.

    ```terraform
    provider "aws" {
      alias  = "management_account"
      region = "us-west-2"
    }

    module "infracost_management_account" {
      source                     = "github.com/infracost/cross-account-link?ref=v0.5.0"
      infracost_external_id      = "INFRACOST_ORGANIZATION_ID"
      is_management_account      = true
      providers = {
        aws = aws.management_account
      }
    }

    output "infracost_management_account_cross_account_role_arn" {
      value = module.infracost_management_account.role_arn
    }
    ```

2. Use the module with `is_management_account = false` to create the cross account role on all member accounts. As above, pass the `infracost_external_id` variable (which points to your Infracost organization ID) to the module.

    ```terraform
    provider "aws" {
      alias  = "member_account_1"
      region = "us-west-2"
    }

    module "infracost_member_account_1" {
      source                     = "github.com/infracost/cross-account-link?ref=v0.3.0"
      infracost_external_id      = "INFRACOST_ORGANIZATION_ID"
      is_management_account      = false
      providers = {
        aws = aws.member_account_1
      }
    }

    output "infracost_member_account_cross_account_role_arns" {
      value = [
        module.infracost_member_account_1.role_arn
      ]
    }
    ```

2. Run `terraform init` and `terraform apply` to create the cross account role in all AWS accounts.

3. Email the `infracost_management_account_cross_account_role_arn` and `infracost_member_account_cross_account_role_arns` outputs to Infracost:

    ```text
    To: support@infracost.io
    Subject: Enable AWS read-only access for Infracost Cloud

    Body:
    Hi, my name is Rafa and I'm the DevOps Lead at ACME Corporation.

    - Infracost Cloud org ID: $YOUR_INFRACOST_ORGANIZATION_ID
    - Our management account Cross Account ARN is:
    <terraform output infracost_management_account_cross_account_role_arn>
    - Our member accounts Cross Account ARNs are:
    <terraform output infracost_member_account_cross_account_role_arns>

    Regards,
    Rafa
    ```

## Updates

When new FinOps policies or features are added, this module may need to be updated to include the new permissions. We will notify you when this is the case so you can update the version of the module.

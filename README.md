# terraform-aws-valtix-iam
This module creates IAM roles required to deploy Valtix gateways

## Example Usage
```hcl
module "iam" {
  source                        = "github.com/valtix-security/terraform-aws-valtix-iam"
  prefix                        = "customer"
  controller_aws_account_number = "12345689012"
  ExternalId                    = "abcdeefghijklmnopqrstuvwxyztlostdkgzmypjegodwrfoahmsasffzoinrabcd"
  region                        = "us-east-1"
  s3_bucket                     = "valtix-customer-s3"
  deployment_name               = "customer"
  #discovery_only		= true
}
```

## Argument Reference

The following arguments are supported:
### Required
* `prefix` - (Required) Prefix appended to resources created
* `controller_aws_account_number` - (Required) AWS controller account number provided by Valtix
* `ExternalId` - (Required) ExternalId found in the create cloud account option in Valtix UI
* `region` - (Required) AWS region to create S3 bucket
* `s3_bucket` - (Required) S3 bucket name for VPC flow logs and DNS query logs for Valtix Discovery
* `deployment_name` - (Required) Account name provided by Valtix

### Optional
* `discovery_only` - (Optional) deploy iam roles for discovery only.

### Output
* `valtix_controller_role_arn` - IAM role for controller in ARN format
* `valtix_firewall_role_name` - IAM role for Valtix Gateway in ARN format

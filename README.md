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
  log_vpc_id                    = ["vpc-0846a3bba3772d1bb","vpc-09bcbaf2f25bf6926"]
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
* `log_vpc_id` - (Optional) List of VPC IDs to associate with Route53 query logging and VPC flow logs for DNS and VPC traffic visibility

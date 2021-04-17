variable "prefix" {
  description = "prefix for resources created in this template"
}

variable "controller_aws_account_number" {
  description = "this is the Valtix provided aws account number"
}

variable "ExternalId" {
  description = "this is the External ID shown on the Add AWS Account on Valtix UI"
  default     = "valtix"
}

variable "region" {
  description = "this is the aws region"
}

variable "s3_bucket" {
  description = "Create S3 Bucket where you want to store cloudtrail, route53 query logs and vpc flow logs"
}

variable "deployment_name" {
  description = "Valtix Controller deployment name"
  default     = "prod1"
}

variable "route53log_vpc_ids" {
  type        = list(string)
  description = "List of VPC IDs to enable Route53 Query Logging for DNS Traffic visibility"
  default     = []
}
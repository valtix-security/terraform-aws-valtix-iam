variable "controller_aws_account_number" {
  type = string
  description = "controller AWS account number"
}

variable "prefix" {
  type = string
  description = "prefix of controller role name"
}

variable "ExternalId" {
  type = string
  description = "External ID"
}

variable "discovery_only" {
  type = bool
  description = "Enable discovery only mode"
  default = false
}

variable "s3_bucket_arn" {
  type = string
  description = "S3 bucket ARN"
}

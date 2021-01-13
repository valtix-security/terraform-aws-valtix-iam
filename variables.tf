variable "prefix" {
    description = "prefix for resources created in this template"
}

variable "controller_aws_account_number" {
  description = "this is the Valtix provided aws account number"
}

variable "ExternalId" {
  description = "this is the External ID shown on the Add AWS Account on Valtix UI"
  default = "valtix"
}

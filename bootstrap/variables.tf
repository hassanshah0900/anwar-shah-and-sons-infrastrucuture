variable "project" {
  type        = string
  description = "The name of the project, used as a naming prefix for resources to maintain clean resource organization."
}

variable "account_id" {
  type        = number
  description = "The 12-digit AWS account ID where the remote state infrastructure will be provisioned."
}

variable "region" {
  type        = string
  description = "The AWS region where the S3 state bucket will be created."
}

variable "project" {
  type        = string
  description = "The name of the project, used as a naming prefix for resources to maintain clean resource organization."
}

variable "region" {
  type        = string
  description = "The AWS region where the S3 state bucket will be created."
}

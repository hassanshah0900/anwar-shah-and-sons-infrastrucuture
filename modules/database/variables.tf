variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the database subnet group and security group will be created."
}

variable "region" {
  type        = string
  description = "The AWS region where the resources will be deployed."
}

variable "project_name" {
  type        = string
  description = "The name of the project, used as a prefix for naming and tagging resources."
}

variable "environment" {
  type        = string
  description = "The deployment environment (e.g., dev, staging, prod)."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "A list of private subnet IDs where the Aurora database instances will be placed."
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Determines whether a final DB snapshot is created before the cluster is deleted. Set to false for production."
}

variable "app_sg_id" {
  type        = string
  description = "The security group ID of the application tier allowed to communicate with the PostgreSQL database."
}

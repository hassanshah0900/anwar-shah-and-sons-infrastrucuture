output "vpc_id" {
  description = "The ID of the main Virtual Private Cloud (VPC)."
  type        = string
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of IDs for the public-facing subnets."
  type        = list(string)
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of IDs for the general private subnets."
  type        = list(string)
  value       = aws_subnet.private[*].id
}

output "db_subnet_ids" {
  description = "List of IDs for the isolated database subnets."
  type        = list(string)
  value       = aws_subnet.db[*].id
}

output "app_subnet_ids" {
  description = "List of IDs for the application tier private subnets."
  type        = list(string)
  value       = aws_subnet.app[*].id
}

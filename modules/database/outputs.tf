output "cluster_endpoint" {
  description = "The writer endpoint for the Aurora PostgreSQL cluster, used for database write operations."
  value       = aws_rds_cluster.postgresql.endpoint
  type        = string
}

output "reader_endpoint" {
  description = "The reader endpoint for the Aurora PostgreSQL cluster, used to distribute read-only queries."
  value       = aws_rds_cluster.postgresql.reader_endpoint
  type        = string
}

output "database_name" {
  description = "The name of the initial default database created inside the cluster."
  value       = aws_rds_cluster.postgresql.database_name
  type        = string
}

output "master_user_secret_arn" {
  description = "The ARN of the AWS Secrets Manager secret containing the automatically managed master database credentials."
  value       = aws_rds_cluster.postgresql.master_user_secret[0].secret_arn
  type        = string
}

output "security_group_id" {
  description = "The security group ID assigned to the Aurora PostgreSQL cluster."
  value       = aws_security_group.postgresql.id
  type        = string
}

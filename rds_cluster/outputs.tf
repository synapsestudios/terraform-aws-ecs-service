
output "db_cluster_id" {
  description = "Identifier of the Aurora PostgreSQL cluster."
  value       = aws_rds_cluster.this.cluster_identifier
}

output "security_group_id" {
  description = "ID of the security group that controls database traffic."
  value       = aws_security_group.this.id
}

output "root_password_secret_id" {
  description = "ID of the Secrets Manager secret that holds the root password for the cluster."
  value       = aws_secretsmanager_secret.root_password.id
}

output "connection_string_arn" {
  description = "ARN of the Secrets Manager secret that holds the PostgreSQL connection string."
  value       = aws_secretsmanager_secret.connection_string.arn
}

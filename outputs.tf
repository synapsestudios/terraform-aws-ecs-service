output "log_group_name" {
  description = "Name of the CloudWatch log group the service's containers send logs to."
  value       = aws_cloudwatch_log_group.service.name
}

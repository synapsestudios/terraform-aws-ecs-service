output "kms_key_id" {
  value       = aws_kms_key.kms.arn
  description = "ARN of the KMS key created for this service's database and secrets"
}
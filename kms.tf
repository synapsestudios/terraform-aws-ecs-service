resource "aws_kms_key" "kms" {
  description         = "${var.service_name} Aurora KMS key"
  enable_key_rotation = true
}
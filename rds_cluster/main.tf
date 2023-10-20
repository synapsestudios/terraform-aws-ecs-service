resource "random_id" "final_snapshot_suffix" {
  byte_length = 8
}

#tfsec:ignore:aws-rds-encrypt-cluster-storage-data
resource "aws_rds_cluster" "this" {
  cluster_identifier_prefix       = var.name
  engine                          = "aurora-postgresql"
  engine_version                  = "14.6"
  database_name                   = var.database_name
  skip_final_snapshot             = false
  final_snapshot_identifier       = "${var.name}-final-${random_id.final_snapshot_suffix.hex}"
  master_username                 = "root"
  master_password                 = aws_secretsmanager_secret_version.root_password.secret_string
  db_subnet_group_name            = aws_db_subnet_group.this.name
  storage_encrypted               = true
  availability_zones              = var.availability_zones
  preferred_backup_window         = "07:00-09:00"
  backup_retention_period         = 30
  vpc_security_group_ids          = concat([aws_security_group.this.id], var.additional_security_groups)
  tags                            = var.tags
  db_cluster_parameter_group_name = "default.aurora-postgresql14"
  deletion_protection             = true
}

resource "random_password" "password" {
  length           = 32
  special          = true
  min_special      = 1
  override_special = "-._~" # URL-safe characters prevent parsing errors when using this password in a connection string
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "root_password" {
  name_prefix = "${var.name}-aurora-root-password"
  description = "Root password for the ${var.name} aurora cluster database"
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "root_password" {
  secret_id     = aws_secretsmanager_secret.root_password.id
  secret_string = random_password.password.result
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "connection_string" {
  name_prefix = "${var.name}-aurora-connection-string"
  description = "Connection String for the ${var.name} aurora cluster database"
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "connection_string" {
  secret_id     = aws_secretsmanager_secret.connection_string.id
  secret_string = "postgresql://${aws_rds_cluster.this.master_username}:${aws_secretsmanager_secret_version.root_password.secret_string}@${aws_rds_cluster.this.endpoint}:${aws_rds_cluster.this.port}/${aws_rds_cluster.this.database_name}"
}

#tfsec:ignore:aws-rds-enable-performance-insights-encryption
resource "aws_rds_cluster_instance" "this" {
  count                        = var.instance_count
  engine                       = "aurora-postgresql"
  engine_version               = "14.6"
  identifier_prefix            = "${var.name}-${count.index + 1}"
  performance_insights_enabled = true
  cluster_identifier           = aws_rds_cluster.this.id
  instance_class               = var.instance_class
  db_subnet_group_name         = aws_db_subnet_group.this.name
  tags                         = var.tags
}

resource "aws_db_subnet_group" "this" {
  name_prefix = var.name
  description = "${var.name} RDS Subnet Group"
  subnet_ids  = var.database_subnets
  tags        = var.tags
}

resource "aws_security_group" "this" {
  name_prefix = "${var.name}-database-access"
  description = "Database traffic rules"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { name = "database" })
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.database_vpc.cidr_block]
    description = "Database ingress"
  }
  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.database_vpc.cidr_block]
    description = "Database egress"
  }
}

data "aws_vpc" "database_vpc" {
  id = var.vpc_id
}

module "database" {
  count              = var.use_database_cluster ? 1 : 0
  source             = "./rds_cluster"
  availability_zones = var.azs
  database_subnets   = var.subnets
  instance_class     = var.db_instance_class
  instance_count     = var.db_instance_count
  name               = var.service_name
  vpc_id             = var.vpc_id
  database_name      = var.db_name
  ca_cert_identifier = var.ca_cert_identifier
  engine_version     = var.rds_cluster_engine_version
}

module "database" {
  count                           = var.use_database_cluster ? 1 : 0
  source                          = "git::https://github.com/synapsestudios/terraform-aws-rds-aurora-cluster.git?ref=v1.0.0"
  availability_zones              = var.azs
  database_subnets                = var.subnets
  db_cluster_parameter_group_name = "default.aurora-postgresql14"
  instance_class                  = "db.t4g.medium"
  name                            = "backend"
  vpc_id                          = var.vpc_id
  database_name                   = "backend"
}
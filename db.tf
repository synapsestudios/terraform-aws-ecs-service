module "database" {
  count                           = var.use_database_cluster ? 1 : 0
  source                          = "git::https://github.com/synapsestudios/terraform-aws-rds-aurora-cluster.git?ref=a8f4ea6a6a5886b2bfeb43d1403a7abfe8e3f0e2"
  availability_zones              = var.azs
  database_subnets                = var.subnets
  db_cluster_parameter_group_name = "default.aurora-postgresql14"
  instance_class                  = "db.t4g.medium"
  name                            = "backend"
  vpc_id                          = var.vpc_id
  database_name                   = "backend"
}
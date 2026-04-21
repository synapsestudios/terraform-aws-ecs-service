
resource "aws_ecs_task_definition" "service" {
  family                   = var.service_name
  container_definitions    = var.container_definitions != null ? var.container_definitions : "[${module.service_container_definition[0].json_map_encoded}]"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  memory                   = var.task_memory
  cpu                      = var.task_cpu
  requires_compatibilities = ["FARGATE"]

  runtime_platform {
    # Required if using Fargate launch type
    operating_system_family = "LINUX"
  }

}

#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "service" {
  name_prefix = var.service_name
}

module "service_container_definition" {
  count = var.container_definitions != null ? 0 : 1

  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.61.1"

  container_name   = var.service_name
  container_image  = var.container_image
  container_memory = 2048
  essential        = true
  environment      = var.environment_variables
  port_mappings    = var.host_port != null ? [{ hostPort = var.host_port, containerPort = var.container_port, protocol = "tcp" }] : [{ hostPort = var.container_port, containerPort = var.container_port, protocol = "tcp" }]
  command          = var.command
  secrets = var.use_database_cluster ? concat([{
    name      = "DATABASE_URL"
    valueFrom = module.database[0].connection_string_arn
  }], var.container_secrets) : var.container_secrets

  log_configuration = {
    logDriver     = "awslogs"
    secretOptions = null,
    options = {
      awslogs-group         = aws_cloudwatch_log_group.service.name
      awslogs-region        = data.aws_region.current.name
      awslogs-stream-prefix = "ecs"
    }
  }
}

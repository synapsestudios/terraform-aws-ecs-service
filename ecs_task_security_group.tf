resource "aws_security_group" "ecs_task" {
  description = "ECS Tasks traffic rules"
  vpc_id      = var.vpc_id
  name_prefix = "${var.service_name}-ecs-task-default"
}

resource "aws_vpc_security_group_egress_rule" "ecs_task_all" {
  security_group_id = aws_security_group.ecs_task.id
  description       = "Allow outgoing connections"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ecs_task_alb_access" {
  security_group_id            = aws_security_group.ecs_task.id
  description                  = "Allow incoming connections from ALB"
  ip_protocol                  = "-1"
  referenced_security_group_id = var.alb_security_group_id
}

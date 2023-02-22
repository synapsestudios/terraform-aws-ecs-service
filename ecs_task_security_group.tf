resource "aws_security_group" "ecs_task" {
  description = "ECS Tasks traffic rules"
  vpc_id      = var.vpc_id
  name_prefix = "${var.service_name}-ecs-task-default"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outgoing connections"
  }
}

resource "aws_security_group_rule" "ecs_task_alb_access" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = var.alb_security_group_id
  description              = "Allow incoming connections from ALB"
  security_group_id        = aws_security_group.ecs_task.id
}
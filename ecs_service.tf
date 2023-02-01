resource "aws_ecs_service" "this" {
  name            = var.service_name
  launch_type     = "FARGATE"
  cluster         = var.cluster_arn
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = var.ecs_desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.service_name
    container_port   = var.container_port
  }

  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.ecs_task.id]
    # If you are using Fargate tasks, in order for the task to pull the container image it must either use a public subnet and be assigned a
    # public IP address or a private subnet that has a route to the internet or a NAT gateway that can route requests to the internet.
    assign_public_ip = false
  }

  # This allows dynamic scaling and external deployments
  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
      load_balancer
    ]
  }

  deployment_controller {
    type = "ECS"
  }
}
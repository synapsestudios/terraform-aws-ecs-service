resource "aws_lb_target_group" "this" {
  name_prefix          = substr(var.service_name, 0, 6)
  port                 = 80
  deregistration_delay = 5
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  #  tags                 = var.tags # TODO

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    enabled             = true
    interval            = 5
    path                = var.health_check_path
    port                = var.container_port
    protocol            = "HTTP"
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200,301,308"
  }

  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 86400
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = var.listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    host_header {
      values = [var.hostname]
    }
  }
}

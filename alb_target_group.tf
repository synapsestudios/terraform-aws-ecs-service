locals {
  common_tg_config = {
    deregistration_delay = 5
    protocol             = "HTTP"
    target_type          = "ip"
    vpc_id               = var.vpc_id

    health_check = {
      enabled             = true
      interval            = 5
      path                = var.health_check_path
      port                = var.container_port
      protocol            = "HTTP"
      timeout             = 3
      healthy_threshold   = 2
      unhealthy_threshold = 3
      matcher             = "200"
    }

    stickiness = {
      enabled         = true
      type            = "lb_cookie"
      cookie_duration = 86400
    }
  }
}

resource "aws_lb_target_group" "blue" {
  name_prefix          = substr(var.service_name, 0, 6)
  port                 = 80
  deregistration_delay = local.common_tg_config.deregistration_delay
  protocol             = local.common_tg_config.protocol
  target_type          = local.common_tg_config.target_type
  vpc_id               = local.common_tg_config.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  health_check = local.common_tg_config.health_check

  stickiness = local.common_tg_config.stickiness
}

resource "aws_lb_listener_rule" "blue" {
  listener_arn = var.listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }

  condition {
    host_header {
      values = [var.hostname]
    }
  }
}

resource "aws_lb_target_group" "green" {
  name_prefix          = substr(var.service_name, 0, 6)
  port                 = 80
  deregistration_delay = local.common_tg_config.deregistration_delay
  protocol             = local.common_tg_config.protocol
  target_type          = local.common_tg_config.target_type
  vpc_id               = local.common_tg_config.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  health_check = local.common_tg_config.health_check

  stickiness = local.common_tg_config.stickiness
}

resource "aws_lb_listener_rule" "green" {
  listener_arn = var.listener_arn_green

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }

  condition {
    host_header {
      values = [var.hostname]
    }
  }
}

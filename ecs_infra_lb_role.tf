resource "aws_iam_role" "ecs_infra_lb_role" {
  name_prefix        = "${substr(var.service_name, 0, 24)}-ecs-infrastructure-role-for-lbs"
  assume_role_policy = data.aws_iam_policy_document.ecs_infrastructure_trust_policy.json
}

// https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AmazonECSInfrastructureRolePolicyForLoadBalancers.html#create-infrastructure-role-loadbalancers
data "aws_iam_policy_document" "ecs_infrastructure_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    sid = "AllowAccessToECSForInfrastructureManagement"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}
# terraform-aws-ecs-service

This is a highly-opinionated ECS Service module for the Synapse Platform. It currently does NOT support blue-green deploys, autoscaling, customizing container sizes, or sidecar containers. It is also overly restrictive with the task role permissions.
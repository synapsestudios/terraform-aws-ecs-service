variable "vpc_id" {
  type        = string
  description = "VPC to deploy into"
}

variable "cluster_arn" {
  type        = string
  description = "ECS cluster to deploy into"
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet names the service will reside on."
}

variable "ecr_host" {
  type        = string
  description = "Hostname of the ECR repository with no trailing slash"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones"
}

variable "environment_variables" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "The environment variables to pass to the container. This is a list of maps."
  default     = []
}

variable "container_secrets" {
  type = list(object({
    name      = string
    valueFrom = string
  }))
  description = "The Secrets to Pass to the container."
  default     = []
}

variable "listener_arn" {
  type        = string
  description = "ALB listener ARN to add listener rule to"
}

variable "alb_security_group_id" {
  type        = string
  description = "Security Group ID for the ALB"
}

variable "command" {
  type        = list(string)
  description = "Container startup command"
}

variable "hostname" {
  type        = string
  description = "Hostname to use for listener rule"
}

variable "service_name" {
  type        = string
  description = "Service directory in the application git repo"
}

variable "container_port" {
  type        = number
  description = "Port exposed by the container"
}

variable "health_check_path" {
  type        = string
  description = "Path to use for health checks"
}

variable "use_database_cluster" {
  type        = bool
  description = "Whether or not we should create a DB cluster and inject the database connection string into the container"
}

variable "use_hostname" {
  type        = bool
  description = "Whether or not we should create a target group and listener to attach this service to a load balancer"
}

variable "ecs_desired_count" {
  type        = number
  default     = 1
  description = "How many tasks to launch in ECS service"
}

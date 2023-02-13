# terraform-aws-ecs-service

This is a highly-opinionated ECS Service module for the Synapse Platform. It currently does NOT support blue-green deploys, autoscaling, customizing container sizes, or sidecar containers. It is also overly restrictive with the task role permissions.

# Known Issues:

Currently we're aware of a bug occurring when trying to change container ports. If you change the container port, the service will not be able to start up due to an association bug between the load balancer target group health check and the ECS service. To correctly update the container port, you must first destroy the service, then update the container port, then re-create the service manually. This is a known issue with Terraform and AWS.

You can do this by commenting out the entire module, running a terraform apply, then uncommenting the module and running a terraform apply again after you've updated the container port.

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                   | Version |
| ------------------------------------------------------ | ------- |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | >= 4.0  |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | >= 4.0  |

## Modules

| Name                                                                                                                    | Source                                                                      | Version |
| ----------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- | ------- |
| <a name="module_database"></a> [database](#module_database)                                                             | git::https://github.com/synapsestudios/terraform-aws-rds-aurora-cluster.git | v0.0.7  |
| <a name="module_service_container_definition"></a> [service_container_definition](#module_service_container_definition) | cloudposse/ecs-container-definition/aws                                     | 0.58.1  |

## Resources

| Name                                                                                                                                                             | Type        |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_cloudwatch_log_group.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group)                             | resource    |
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service)                                                  | resource    |
| [aws_ecs_task_definition.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition)                               | resource    |
| [aws_iam_role.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                     | resource    |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                               | resource    |
| [aws_iam_role_policy_attachment.cognito](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)                 | resource    |
| [aws_iam_role_policy_attachment.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_iam_role_policy_attachment.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)                      | resource    |
| [aws_iam_role_policy_attachment.secrets_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)         | resource    |
| [aws_iam_role_policy_attachment.ses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)                     | resource    |
| [aws_lb_listener_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule)                                        | resource    |
| [aws_lb_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group)                                          | resource    |
| [aws_security_group.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                        | resource    |
| [aws_security_group_rule.ecs_task_alb_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)                   | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                                    | data source |
| [aws_iam_policy_document.assume_ecs_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)             | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                                      | data source |

## Inputs

| Name                                                                                             | Description                                                                                               | Type                                                                      | Default | Required |
| ------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- | ------- | :------: |
| <a name="input_alb_security_group_id"></a> [alb_security_group_id](#input_alb_security_group_id) | Security Group ID for the ALB                                                                             | `string`                                                                  | n/a     |   yes    |
| <a name="input_azs"></a> [azs](#input_azs)                                                       | Availability zones                                                                                        | `list(string)`                                                            | n/a     |   yes    |
| <a name="input_cluster_arn"></a> [cluster_arn](#input_cluster_arn)                               | ECS cluster to deploy into                                                                                | `string`                                                                  | n/a     |   yes    |
| <a name="input_command"></a> [command](#input_command)                                           | Container startup command                                                                                 | `list(string)`                                                            | n/a     |   yes    |
| <a name="input_container_port"></a> [container_port](#input_container_port)                      | Port exposed by the container                                                                             | `number`                                                                  | n/a     |   yes    |
| <a name="input_container_secrets"></a> [container_secrets](#input_container_secrets)             | The Secrets to Pass to the container.                                                                     | <pre>list(object({<br> name = string<br> valueFrom = string<br> }))</pre> | `[]`    |    no    |
| <a name="input_ecr_host"></a> [ecr_host](#input_ecr_host)                                        | Hostname of the ECR repository with no trailing slash                                                     | `string`                                                                  | n/a     |   yes    |
| <a name="input_ecs_desired_count"></a> [ecs_desired_count](#input_ecs_desired_count)             | How many tasks to launch in ECS service                                                                   | `number`                                                                  | `1`     |    no    |
| <a name="input_environment_variables"></a> [environment_variables](#input_environment_variables) | The environment variables to pass to the container. This is a list of maps.                               | <pre>list(object({<br> name = string<br> value = string<br> }))</pre>     | `[]`    |    no    |
| <a name="input_health_check_path"></a> [health_check_path](#input_health_check_path)             | Path to use for health checks                                                                             | `string`                                                                  | n/a     |   yes    |
| <a name="input_host_port"></a> [host_port](#input_host_port)                                     | Port exposed by the host                                                                                  | `number`                                                                  | `null`  |    no    |
| <a name="input_hostname"></a> [hostname](#input_hostname)                                        | Hostname to use for listener rule                                                                         | `string`                                                                  | n/a     |   yes    |
| <a name="input_listener_arn"></a> [listener_arn](#input_listener_arn)                            | ALB listener ARN to add listener rule to                                                                  | `string`                                                                  | n/a     |   yes    |
| <a name="input_service_name"></a> [service_name](#input_service_name)                            | Service directory in the application git repo                                                             | `string`                                                                  | n/a     |   yes    |
| <a name="input_subnets"></a> [subnets](#input_subnets)                                           | List of subnet names the service will reside on.                                                          | `list(string)`                                                            | n/a     |   yes    |
| <a name="input_use_database_cluster"></a> [use_database_cluster](#input_use_database_cluster)    | Whether or not we should create a DB cluster and inject the database connection string into the container | `bool`                                                                    | n/a     |   yes    |
| <a name="input_use_hostname"></a> [use_hostname](#input_use_hostname)                            | Whether or not we should create a target group and listener to attach this service to a load balancer     | `bool`                                                                    | n/a     |   yes    |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id)                                              | VPC to deploy into                                                                                        | `string`                                                                  | n/a     |   yes    |

## Outputs

No outputs.

<!-- END_TF_DOCS -->

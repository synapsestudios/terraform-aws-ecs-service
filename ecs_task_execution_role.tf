resource "aws_iam_role" "ecs_task_execution_role" {
  name_prefix = "${substr(var.service_name, 0, 14)}-ecs-task-execution-role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "kms_decryption" {
  name_prefix = "${var.service_name}-kms-decrypt"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Decrypt",
        ]
        Effect   = "Allow"
        Resource = aws_kms_key.kms.arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kms_decryption" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.kms_decryption.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "secrets_manager" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}
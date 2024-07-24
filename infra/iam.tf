resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole-${var.project_name}"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "ecs-tasks.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
  }
  EOF
}

resource "aws_iam_policy" "ecs_task_s3_read_policy" {
  name        = "ecs-task-s3-read-policy"
  description = "Policy to allow ECS task to read from S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
        ],
        Resource = [
          "arn:aws:s3:::live-orders-327498361889",
          "arn:aws:s3:::live-orders-327498361889/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_s3_read_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_ecs_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-${var.env}-cluster"
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "/ecs/${var.project_name}-${var.env}-task-definition"
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "${var.project_name}-${var.env}-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu    # CPU Units for the task
  memory                   = var.memory # Available memory for the task
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  depends_on               = [aws_s3_bucket.live_orders_bucket]

  container_definitions = jsonencode([
    {
      name  = "${var.project_name}-${var.env}-con"
      image = var.docker_image_name
      essential : true

      portMappings = [
        {
          containerPort = tonumber(var.container_port)
          hostport      = tonumber(var.container_port)
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ],

      # Read environments from S3
      environmentFiles = [
        {
          value = var.s3_env_vars_file_arn,
          type  = "s3"
        }
      ],

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-create-group"  = "true"
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_log_group.name
          "awslogs-region"        = var.awslogs_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.project_name}-service"
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = 1

  network_configuration {
    assign_public_ip = true
    subnets          = [module.vpc.public_subnets[0]]
    security_groups  = [module.container_security_group.security_group_id]
  }

  health_check_grace_period_seconds = 0
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    container_name   = "${var.project_name}-${var.env}-con"
    container_port   = var.container_port
  }
}
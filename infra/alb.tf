resource "aws_lb" "ecs_alb" {
  name               = "${var.project_name}-${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.alb_security_group.security_group_id]
  subnets            = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
}

resource "aws_lb_target_group" "ecs_target_group" {
  name        = "${var.project_name}-${var.env}-target-group"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    path                = var.health_check_path
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
  }
}
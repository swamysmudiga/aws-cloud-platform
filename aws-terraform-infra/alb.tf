# Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_security_group.id] # Security group for load balancer
  subnets            = aws_subnet.public_subnets[*].id           # Public subnets for ALB

  enable_deletion_protection = false
}

# Target Group for the Auto Scaling Group
resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.csye6225_Swamy_Dev.id

  health_check {
    path                = "/healthz" # Health check path
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Load Balancer Listener
#resource "aws_lb_listener" "app_listener" {
#load_balancer_arn = aws_lb.app_lb.arn
#port              = 80
#protocol          = "HTTP"

#default_action {
#type             = "forward"
#target_group_arn = aws_lb_target_group.app_tg.arn
#}
#}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = data.aws_acm_certificate.ssl_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

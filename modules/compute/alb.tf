resource "aws_lb" "weblb" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.public_subnets

}

resource "aws_lb_target_group" "mytg" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"
  
  # 1. Enabling Stickiness for Session Persistence 
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400 # 1 day in seconds
    enabled         = true
  }
  # Health check configuration
  health_check {
    enabled = true
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

}

resource "aws_lb_target_group_attachment" "instance_attachment" {
      count           = var.instance_count
      target_group_arn = aws_lb_target_group.mytg.arn
      target_id        = aws_instance.myinstance[count.index].id # since you have an output for instance IDs in the  compute module
      port             = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.weblb.arn
  port              = "80"
    protocol          = "HTTP"
    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.mytg.arn
    }
}

    
resource "aws_security_group" "lb_sg" {
  name        = "lb-security-group"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to the world for web access 
  }
   egress { 
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}
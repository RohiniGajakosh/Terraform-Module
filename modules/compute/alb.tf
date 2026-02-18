resource "aws_lb" "applb" {
  name               = "my-application-load-balancer"
  internal           = false #publically faced loadbalancer
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.public_subnets  #attached to muliple subnets in different availability zone
   access_logs {
    bucket  = var.bucketname
    prefix  = "alb-access"
    enabled = false
  }
  depends_on = [
    var.alb_logs_policy_dependency
  ]
}

resource "aws_lb_target_group" "mytg" {
  name     = "my-applb-target-group"
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

# resource "aws_lb_target_group_attachment" "instance_attachment" {
#       count           = var.instance_count
#       target_group_arn = aws_lb_target_group.mytg.arn
#       target_id        = aws_instance.myinstance[count.index].id # since you have an output for instance IDs in the  compute module
#       port             = 80
# }

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.applb.arn
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

resource "aws_launch_template" "apptemplate"{
  name_prefix = "app-template"
  image_id =  data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name = "awskey"
  network_interfaces {
    associate_public_ip_address = "false"
    security_groups = [aws_security_group.web_sg.id]
  }
  user_data = filebase64("${path.module}/userdata.sh")
  tag_specifications {
    resource_type = "instance"
    tags = merge(
    local.commontags,
    {
      Name = "MyInstance" 
    }
    )
  }

}

resource "aws_autoscaling_group" "myasg" {
  name = "my-asg"
  max_size = 3
  min_size = 1
  desired_capacity = 2
  target_group_arns = [aws_lb_target_group.mytg.arn]
  vpc_zone_identifier = var.private_subnets
  launch_template {
    id = aws_launch_template.apptemplate.id
    version = "$Latest"
  }
  health_check_type = "ELB"
  health_check_grace_period = 300

}
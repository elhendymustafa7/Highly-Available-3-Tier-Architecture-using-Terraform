resource "aws_launch_template" "launch_template" {
  name          = "aws-launch-template"
  image_id      = var.image_id
  instance_type = var.instance_type

  network_interfaces {
    device_index    = 0
    security_groups = [var.webserver_security_group_id]
  }
  user_data = base64encode("${var.user_data}")

  tags = {
    Name = "asg-ec2-template"
  }
}



resource "aws_autoscaling_group" "auto_scaling_group" {
  desired_capacity    = 2
  max_size            = 5
  min_size            = 2
  vpc_zone_identifier = [var.public_subnet_ids[0],var.public_subnet_ids[1]]
  target_group_arns   = [aws_lb_target_group.lb_target_group.arn] #######
  name = "ec2-asg"

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = aws_launch_template.launch_template.latest_version
  }
  depends_on = [aws_launch_template.launch_template , aws_lb.alb]
}


resource "aws_lb" "alb" {
  name               = "public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = [var.public_subnet_ids[0],var.public_subnet_ids[1]]
}

resource "aws_lb_target_group" "lb_target_group" {
  name     = "lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}

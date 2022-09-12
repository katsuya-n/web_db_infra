resource "aws_lb" "alb" {
  // name_prefixだと文字数が多すぎたので直書き
  name               = "lightkun-test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_alb_id]
  subnets            = [var.subnet_az_2a_id, var.subnet_az_2b_id]

  enable_deletion_protection = false


  tags = {
    Environment = "dev"
  }
}

resource "aws_lb_target_group" "alb_to_ec2" {
  // name_prefixだと文字数が多すぎたので直書き
  name     = "lightkun-test-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "alb_to_ec2" {
  target_group_arn = aws_lb_target_group.alb_to_ec2.arn
  target_id        = var.aws_instance_web_id
  port             = 80
}

resource "aws_lb_listener" "alb_to_ec2" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_to_ec2.arn
  }
}
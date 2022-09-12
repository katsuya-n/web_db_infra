resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-sg-alb"
  description = "sg alb"
  vpc_id      = var.vpc_id

  ingress {
    description = "my ip"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allow_cidr_block]
  }
  ingress {
    description = "my ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allow_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg-alb"
  }
}

resource "aws_security_group" "ec2" {
  name        = "${var.name_prefix}-sg-ec2"
  description = "ec2 alb"
  vpc_id      = var.vpc_id

  ingress {
    description     = "alb"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
  // 検証で、ALBのsgからアクセスできるようにする
  ingress {
    description     = "alb"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg-ec2"
  }
}
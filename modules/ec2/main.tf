resource "aws_instance" "web" {
  // 検証で使いたいだけなのでAMI IDを直接指定
  ami                    = var.ec2_ami_id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [var.sg_id]
  subnet_id              = var.subnet_id
  key_name               = var.key_name

  tags = {
    Name = "${var.name_prefix}-web"
  }
}

resource "aws_instance" "bastion" {
  // 検証で使いたいだけなのでAMI IDを直接指定
  ami                         = var.ec2_ami_id
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [var.bastion_sg_id]
  subnet_id                   = var.bastion_subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = "true"

  tags = {
    Name = "${var.name_prefix}-bastion"
  }
}
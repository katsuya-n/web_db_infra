resource "aws_eip" "nat_2a" {
  vpc = true

  tags = {
    Name = "${var.name_prefix}-eip"
  }
}
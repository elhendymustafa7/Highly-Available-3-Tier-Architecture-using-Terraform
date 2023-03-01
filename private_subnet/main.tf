resource "aws_subnet" "private_subnet" {
  count                   = length(var.cidr_block)
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet ${count.index} | ${var.tags}"
  }
}

resource "aws_eip" "eip_nat" {
  vpc = true

  tags = {
    Name = "eip1"
  }
}

resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = var.subnet_id

  tags = {
    "Name" = "nat1"
  }
}
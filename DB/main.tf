resource "aws_db_subnet_group" "database-subnet-group" {
  name        = "database subnets"
  subnet_ids  = [var.subnets_ids[0],var.subnets_ids[1]]
  description = "Subnet group for database instance"

  tags = {
    Name = "Database Subnets"
  }
}

resource "aws_db_instance" "database-instance" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  db_name                = "sqldb"
  username               = "joesql"
  password               = "qwertypoiu12"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  availability_zone      = "us-east-1b"
  db_subnet_group_name   = aws_db_subnet_group.database-subnet-group.name
  multi_az               = true
  vpc_security_group_ids = [var.DB_security_group_id]
}
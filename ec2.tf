########################
###    Data source   ###
########################

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
########################
###    Ec2 Instance  ###
########################


resource "aws_instance" "PublicWebTemplate" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              =  module.public_subnet_web_tr.public_subnet_ids[0] 
  vpc_security_group_ids = [module.sg.webserver_security_group_id] #[aws_security_group.webserver-security-group.id]
  key_name               = "3tier"
  user_data              = file("install-apache.sh")

  tags = {
    Name = "web-asg"
  }
}


resource "aws_instance" "private-app-template" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = module.public_subnet_web_tr.private_subnet_ids[0]
  vpc_security_group_ids = [module.sg.ssh_security_group_id]
  key_name               = "3tier"

  tags = {
    Name = "app-asg"
  }
}




variable "image_id" {
  
}
variable "instance_type" {
  
}
variable "webserver_security_group_id" {
  
}
variable "public_subnet_ids" {
  
}
variable "alb_security_group_id" {
  
}
variable "vpc_id" {
  
}
variable "availability_zone" {
  
}

variable "user_data" {
  description = "boostrap script for apache"
  type        = string
  default     = <<EOF
  #!/bin/bash
    

sudo su

sudo yum update -y

sudo yum install -y httpd

sudo systemctl enable httpd

sudo systemctl start httpd

sudo echo "<h1> Hello From Our App" > /var/www/html/index.html

EOF
}
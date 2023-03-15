module "vpc" {
  source   = "./vpc"
  vpc_cidr = var.vpc_cidr
}

module "public_subnet_web_tr" {
  source            = "./public_subnet"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zone = ["us-east-1a", "us-east-1b"]
}

module "nat" {
  source = "./nat"
  subnet_id = module.public_subnet_web_tr.public_subnet_ids[0]
}

module "private_subnet_app_tr" {
  source            = "./private_subnet"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zone = ["us-east-1a", "us-east-1b"]
  tags              = "App Tier"
  nat_gateway_id    = module.nat.nat_id
}

module "private_subnet_db_tr" {
  source            = "./private_subnet"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = ["10.0.5.0/24", "10.0.6.0/24"]
  availability_zone = ["us-east-1a", "us-east-1b"]
  tags              = "DB Tier"
  nat_gateway_id    = module.nat.nat_id
}

module "sg" {
  source = "./sg"
  vpc_id = module.vpc.vpc_id
  
}

module "public_alb_asg" {
  source = "./public_alb_asg"
  vpc_id = module.vpc.vpc_id
  image_id = "ami-05fa00d4c63e32376"
  instance_type ="t2.micro"
  webserver_security_group_id = module.sg.webserver_security_group_id 
  public_subnet_ids = module.public_subnet_web_tr.public_subnet_ids
  alb_security_group_id = module.sg.alb_security_group_id
  availability_zone = ["us-east-1a", "us-east-1b"]
}
module "private_alb_asg" {
  source = "./private_alb_asg"
  vpc_id = module.vpc.vpc_id
  image_id = "ami-05fa00d4c63e32376"
  instance_type ="t2.micro"
  webserver_security_group_id = module.sg.webserver_security_group_id 
  public_subnet_ids = module.public_subnet_web_tr.public_subnet_ids
  alb_security_group_id = module.sg.alb_security_group_id
  availability_zone = ["us-east-1a", "us-east-1b"]
}

module "DB" {
  source = "./DB"
  subnets_ids = module.private_subnet_app_tr.private_subnet_ids
  DB_security_group_id = module.sg.DB_security_group_id
}
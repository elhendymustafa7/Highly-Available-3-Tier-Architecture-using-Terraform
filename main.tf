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

module "alb" {
  source = "./alb"
  vpc_id = module.vpc.vpc_id
  
}

module "sg" {
  source = "./sg"
  vpc_id = module.vpc.vpc_id

}


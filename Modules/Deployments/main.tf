provider "aws" {
  region = "us-east-1"
}

module "custom_vpc_ec2" {
  source           = "../Custom_vpc_ec2"
  vpc_cidr         = "10.0.0.0/16"
  subnet_count     = 3
  ami_id           = "ami-0c398cb65a93047f2"
  instance_type    = "t3.micro"
  assign_public_ip = true
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_ami" {
  type    = string
  default = "ami-0c398cb65a93047f2"
}

variable "aws_instance_type" {
  type    = string
  default = "t3.micro"
}

output "vpc_id" {
  value = module.custom_vpc_ec2.vpc_id
}

output "instance_id" {
  value = module.custom_vpc_ec2.instance_id
}

output "instance_public_ip" {
  value = module.custom_vpc_ec2.instance_public_ip
}

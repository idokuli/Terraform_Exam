output "vpc_id" {
  value = aws_vpc.main_vpc.id
}
output "instance_id" {
  value = aws_instance.instance1.id
}
output "instance_public_ip" {
  value = aws_instance.instance1.public_ip
}

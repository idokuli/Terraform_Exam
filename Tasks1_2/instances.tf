resource "aws_instance" "instance1" {
  ami                         = var.aws_ami
  instance_type               = var.aws_instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.sg.id]
  tags = {
    Name = "instance1"
  }
}

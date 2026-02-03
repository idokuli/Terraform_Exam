resource "aws_instance" "instance1" {
  ami                         = "ami-0c398cb65a93047f2"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.sg.id]
  tags = {
    Name = "instance1"
  }
}

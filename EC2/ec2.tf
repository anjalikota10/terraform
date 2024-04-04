
resource "aws_instance" "web" {
  ami           = "var.ami_type"
  instance_type = "t2.small"
  subnet_id = "subnet-021ec554a6cb695fb"
  key_name ="new-virginia-key"

  tags = {
    Name = "HelloWorld"
  }
}
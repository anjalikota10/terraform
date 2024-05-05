
resource "aws_instance" "web" {
  count         = 3
  ami           = var.ami_type
  instance_type = var.instance_type
  key_name      = "docker-key"
  subnet_id     = "subnet-0629e40dd5c72b6fe"

  tags = merge(
    {
      "Name" = "Instance-${count.index}"
    },
    local.common_tags
  )

}
output "ec2_public_ip" {
  value       = aws_instance.web.*.public_ip
  description = "public ip of ec2 instance"

}

output "ec2_private_ip" {
  value       = aws_instance.web.*.private_ip
  description = "private ip of ec2 instance"

}
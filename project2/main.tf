# Define the AWS provider configuration.
provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region.
}

variable "cidr" {
  default = "10.0.0.0/16"
}

resource "aws_key_pair" "example" {
  key_name   = "terraform-key"  # Replace with your desired key name
  public_key = file("/home/codespace/.ssh/terraform-key.pub")  # Replace with the path to your public key file
}

resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true   # do i want the public ip shown
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
}

# EC2 instance configuration
resource "aws_instance" "server" {
  ami                    = "ami-0261755bbcb8c4a84"
  instance_type          = "t2.micro"
  key_name      = aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub1.id

# telling terraform how to connect to the instance we created
  connection {
    type        = "ssh"
    user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
    #providing private key info coz public key is uploaded to ec2 or keypair resource of aws but to connect to instance we need priv key 
    private_key = file("/home/codespace/.ssh/terraform-key")  # Replace with the path to your private key 
    host        = self.public_ip
  }

  # Provisioner to create directory and copy HTML file
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /var/www/html",  # Create directory if not exists
      "sudo chown ubuntu:ubuntu /var/www/html",  # Change ownership to user ubuntu
    ]
  }

 # File provisioner to copy an HTML file from local to the remote EC2 instance
  provisioner "file" {
    source      = "index.html"  # Replace with the path to your HTML file
    destination = "/var/www/html/index.html"  # Replace with the path on the remote instance
  }

  # Provisioner to install and configure a web server to serve the HTML file
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",  # Update package lists (for ubuntu)
      "sudo apt install -y apache2",  # Install Apache HTTP server
      "sudo systemctl start apache2",  # Start Apache service
      "sudo systemctl enable apache2"  # Enable Apache service to start on boot
    ]
  }


}

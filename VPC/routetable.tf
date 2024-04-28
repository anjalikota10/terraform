# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "vpc-0bd0bf085306d6b6c"

   tags = {
    Name = "myIGW"  # Change to your desired name
  }
}

# Create a route table for the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = "vpc-0bd0bf085306d6b6c"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "igw-0a5b3497816b350dc"
  }

  tags = {
    Name = "publicRT"  # Change to your desired name
  }
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = "subnet-00c808840116e94c6"
  route_table_id = "rtb-0ac927c995f4baad7"
}

# Create a route table for the private subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = "vpc-0bd0bf085306d6b6c"

  tags = {
    Name = "privateRT"  # Change to your desired name
  }
}

# Associate the private subnet with the private route table
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = "subnet-0d7b6d6f17d17f888"
  route_table_id = "rtb-0acdd78a0d6f52098"
}


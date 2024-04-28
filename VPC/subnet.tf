# Define the public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = "vpc-0bd0bf085306d6b6c"
  cidr_block              = "10.0.1.0/24"  # Define the CIDR block for the public subnet
  availability_zone       = "ap-south-1a"   # Specify the availability zone

  tags = {
    Name = "public-subnet"  # Change to your desired name
  }
}

# Define the private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = "vpc-0bd0bf085306d6b6c"
  cidr_block              = "10.0.2.0/24"  # Define the CIDR block for the public subnet
  availability_zone       = "ap-south-1a"   # Specify the availability zone

  tags = {
    Name = "private-subnet"  # Change to your desired name
  }
}
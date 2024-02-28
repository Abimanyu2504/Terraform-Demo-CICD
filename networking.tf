# Creating a VPC

resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "Demo-VPC"
  }
}

# Creating Web Public subnet-1

resource "aws_subnet" "web-subnet-1" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "web-1a"
  }
}

# Creating Web Public subnet-2

resource "aws_subnet" "web-subnet-2" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "web-2b"
  }
}

# Creating App Public subnet-1

resource "aws_subnet" "app-subnet-1" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.11.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "app-1a"
  }
}

# Creating App Public subnet-2

resource "aws_subnet" "app-subnet-2" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.12.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "app-2b"
  }
}

# Creating Database Private subnet

resource "aws_subnet" "database-subnet-1" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.21.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "db-1a"
  }
}

# Creating App Public subnet-2

resource "aws_subnet" "database-subnet-2" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.22.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "db-2b"
  }
}

# Creating Internet gatway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    "Name" = "Demo IGW"
  }    
}
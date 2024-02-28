# Creating routing table

resource "aws_route_table" "web-RT" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "web-RT"
  }
}

# Subnet Association

resource "aws_route_table_association" "subnet-association-1" {
  subnet_id      = aws_subnet.web-subnet-1.id
  route_table_id = aws_route_table.web-RT.id
}

resource "aws_route_table_association" "subnet-association-2" {
  subnet_id      = aws_subnet.web-subnet-2.id
  route_table_id = aws_route_table.web-RT.id
}
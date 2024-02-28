# Creating Web security group

resource "aws_security_group" "web-sg" {
  name = "web-sg"
  vpc_id = aws_vpc.my-vpc.id
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 80
    protocol = "tcp"
    to_port = 80
  }

  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }

  tags = {
    "Name" = "Web-SG"
  }
}

# Creating App security group

resource "aws_security_group" "app-sg" {
  name = "app-sg"
  vpc_id = aws_vpc.my-vpc.id
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 80
    protocol = "tcp"
    to_port = 80
    security_groups = [ aws_security_group.web-sg.id ]
  }

  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }
  tags = {
    "Name" = "App-SG"
  }
}

resource "aws_security_group" "data-sg" {
  name = "data-sg"
  vpc_id = aws_vpc.my-vpc.id
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
    security_groups = [ aws_security_group.web-sg.id ]
  }

  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }
  tags = {
    "Name" = "Data-SG"
  }
}
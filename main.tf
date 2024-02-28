# Creating AMI data

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Creating an EC2 instance

resource "aws_instance" "webserver1" {
  ami = data.aws_ami.ubuntu
  instance_type = "t2.micro"
  availability_zone = "ap-south-1a"
  vpc_security_group_ids = [ aws_security_group.web-sg.id ]
  subnet_id = aws_subnet.web-subnet-1.id
  user_data = file("install_apache.sh")
  tags = {
    Name = "webserver1"
  }
}

# Creating an Ec2 instance

resource "aws_instance" "webserver2" {
  ami = data.aws_ami.ubuntu
  instance_type = "t2.micro"
  availability_zone = "ap-south-1b"
  vpc_security_group_ids = [ aws_security_group.web-sg.id ]
  subnet_id = aws_subnet.web-subnet-2.id
  user_data = file("install_apache.sh")
  tags = {
    Name = "webserver2"
  }
}

# Creating Application Load Balancer

resource "aws_lb" "external-elb" {
  name               = "external-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.web-sg.id ]
  subnets            = [ aws_subnet.web-subnet-1.id, aws_subnet.web-subnet-2 ]
  tags = {
    Environment = "Demo"
  }
}

# Creating LoadBalancer target group

resource "aws_lb_target_group" "external-elb" {
  name        = "external-LB-TG"
  target_type = "alb"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.my-vpc.id

  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 10
    timeout = 5 
    interval = 10
    path = "/"
    port = "80"
  }
}

# Attaching target group to webserver1

resource "aws_lb_target_group_attachment" "external-elb1" {
  target_group_arn = aws_lb_target_group.external-elb.arn
  target_id        = aws_instance.webserver1.id
  port             = 80

  depends_on = [ aws_instance.webserver1 ]
}

# Attaching target group to webserver2

resource "aws_lb_target_group_attachment" "external-elb2" {
  target_group_arn = aws_lb_target_group.external-elb.arn
  target_id        = aws_instance.webserver2.id
  port             = 80

  depends_on = [ aws_instance.webserver2 ]
}

# Adding listners to Load Balancer

resource "aws_lb_listener" "external-elb" {
  load_balancer_arn = aws_lb.external-elb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external-elb.arn
  }
}

# Creating database subnet group

resource "aws_db_subnet_group" "subnet" {
  name = "subnet group"
  subnet_ids = [aws_subnet.database-subnet-1.id,aws_subnet.database-subnet-2.id]
}

# Creating a database instance

resource "aws_db_instance" "mydb" {
  allocated_storage    = 5
  db_subnet_group_name = aws_db_subnet_group.subnet.id
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  username             = "mydb"
  password             = "moni2522"
  skip_final_snapshot  = true
  vpc_security_group_ids = [ aws_security_group.data-sg ]
}
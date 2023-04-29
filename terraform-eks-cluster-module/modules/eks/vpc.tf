resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks"
  }
}

resource "aws_route_table" "eksdefault" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eksdefault.id
  }

  tags = {
    Name = "eksdefault"
  }
}

resource "aws_route" "default" {
  route_table_id         = aws_route_table.eksdefault.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.eksdefault]
  gateway_id             = aws_internet_gateway.eksdefault.id
}

resource "aws_internet_gateway" "eksdefault" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "eksdefault"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1c"
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "association_1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.eksdefault.id
}

resource "aws_route_table_association" "association_2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.eksdefault.id
}

resource "aws_route_table_association" "association_3" {
  subnet_id      = aws_subnet.subnet_3.id
  route_table_id = aws_route_table.eksdefault.id
}

resource "aws_security_group" "eksdefaultControlPlane" {
  name   = "eksdefaultControlPlane"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
  }
}
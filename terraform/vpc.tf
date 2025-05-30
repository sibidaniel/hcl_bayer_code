resource "aws_vpc" "vpc_web" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "vpc_web"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.vpc_web.id
  cidr_block = "10.10.1.0/24"
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.vpc_web.id
  cidr_block = "10.10.2.0/24"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_web.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc_web.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc_web.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.vpc_web.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "public_sg"
  }
}   

resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.vpc_web.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.public_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.10.2.0/24"]
  }
  tags = {
    Name = "private_sg"
  }
}

resource "aws_eip" "nat" {
  tags = {
    Name = "nat_eip"
  }   
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "nat_gateway"
  }
}
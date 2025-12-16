provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "oracle_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "oracle-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.oracle_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "oracle-public-subnet"
  }
}

resource "aws_security_group" "oracle_sg" {
  name   = "oracle-sg"
  vpc_id = aws_vpc.oracle_vpc.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Oracle Listener"
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "basic" {
  cidr_block = "172.16.0.0/16"
}

resource "aws_subnet" "basic_subnet" {
  vpc_id = aws_vpc.basic.id
  cidr_block = "172.16.1.0/24"
}

resource "aws_instance" "simple" {
  ami = "ami-40d28157"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.basic_subnet.id
}

  

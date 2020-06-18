/******************************************************************************************
* This file implements Network components as per the assignment requirements.             *
******************************************************************************************/

provider "aws" {
  region = "us-east-1"
}

# Use S3 as the backend for Terraform state

terraform {
  backend "s3" {
    bucket = "pubcloud-tf-state"
    key = "exercise6/network/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-locks"
    encrypt = true
  }
}

# Data Sources

data "aws_availability_zones" "available" {
  state = "available"
}

# Create VPC

resource "aws_vpc" "main" {
  cidr_block                       = "172.16.0.0/16"
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true
}

# Create Public and Private subnets in two AZs

resource "aws_subnet" "public_subnet_1" {
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = "172.16.1.0/24"
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 1)
  assign_ipv6_address_on_creation = true
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = "172.16.3.0/24"
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 3)
  assign_ipv6_address_on_creation = true
  availability_zone = data.aws_availability_zones.available.names[1]
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = "172.16.2.0/24"
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 2)
  assign_ipv6_address_on_creation = true
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = "172.16.4.0/24"
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 4)
  assign_ipv6_address_on_creation = true
  availability_zone = data.aws_availability_zones.available.names[1]
}

# Create an Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Create a Route Table with the default route pointed to the IGW

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw.id
  }
}

# Associate the Public Route Table with Public Subnet in each AZ

resource "aws_route_table_association" "az1_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "az2_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

/******************************************************************************************
* This defines the outputs for Network resources.                                         *
******************************************************************************************/

output "vpc_id" {
  value = aws_vpc.main.id
  description = "The ID of the main VPC"
}

output "private_subnet_1_id" {
  value = aws_subnet.private_subnet_1.id
  description = "The ID of the first private subnet"
}

output "private_subnet_2_id" {
  value = aws_subnet.private_subnet_2.id
  description = "The ID of the second private subnet"
}

output "public_subnet_1_id" {
  value = aws_subnet.public_subnet_1.id
  description = "The ID of the first public subnet"
}

output "public_subnet_2_id" {
  value = aws_subnet.public_subnet_2.id
  description = "The ID of the second public subnet"
}

output "public_subnet_1_cidr" {
  value = aws_subnet.public_subnet_1.cidr_block
  description = "The IPv4 CIDR block of the first public subnet"
}

output "public_subnet_2_cidr" {
  value = aws_subnet.public_subnet_2.cidr_block
  description = "The IPv4 CIDR block of the second public subnet"
}

output "public_subnet_1_ipv6_cidr" {
  value = aws_subnet.public_subnet_1.ipv6_cidr_block
  description = "The IPv6 CIDR block of the first public subnet"
}

output "public_subnet_2_ipv6_cidr" {
  value = aws_subnet.public_subnet_2.ipv6_cidr_block
  description = "The IPv6 CIDR block of the second public subnet"
}

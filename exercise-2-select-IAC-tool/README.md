# Exercise 2 - Select an Infrastructure as Code Tool

For this assignment I chose to use Terraform. I created a simple VPC with one subnet and 
created an EC2 instance in that subnet. I then destroyed my deployment and modified my
Terraform file to change the CIDR block for the VPC/subnet. I then recreated my 
environment before finally destroying it.

There are three files in this directory

README.md - This file
Assignment-2.md - Screen output from my assignment
main.tf - The Terraform file I used for this assignment
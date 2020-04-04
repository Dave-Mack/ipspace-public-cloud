# Exercise 4 and 5  - Deploy a Virtual Network Infrastructure - Dual Stack

**Exercise 4** was to deploy the virtual network infrastructure as specified for IPv4 networking.
I used Terraform to create a virtual network infrastructure in AWS. I created a VPC with
two subnets, one private and one public. For Internet access, I also implemented the
optional elastic network interfaces and elastic IPs for the Web Server and Jump Server.
For my AMIs, I used Packer to create an AMI for my Web Server and another for both my Jump
Server and my App Server. To verify connectivity, I created an Ansible playbook to perform
various network tests. 

**Exercise 5** involved enabling the virtual network for dual stack IPv4/IPv6 networking.
I opted to do both at the same time. 

## Resources Created

### VPC
* Web Server Security Group - IPv4 and IPv6 rules
* Jump Server Security Group - IPv4 and IPv6 rules

### Public Subnet:
* Web Server - I reused the Web Server from previous exercises
* Jump Server - SSH Jump Server to allow access to private resources
* IGW - Internet Gateway for both IPv4 and IPv6
* ENI and Elastic IPs - For Web Server and Jump Server
* Route Table - For the public subnet. Default route pointed to IGW for IPv4 and IPv6

### Private Subnet:
* App Server

## Verification

I used Ansible to verify my Infrastructure for both IPv4 and IPv6. I created a local hosts
file for Ansible that used the ProxyCommand option for the App Sever so Ansible could
use the Jump Server to access it. For testing I expected some tests to fail, notably, the
App Server reaching resources outside the VPC, so I configured Ansible to ignore failures
and continue processing the playbook. 


## Files in this directory

* README.md - This file
* main.tf - The Terraform file I used for this assignment
* screen-capture.png - Screen capture of the web page
* ansible-test-results.txt - Test results from my automated test run using Ansible
* cloud_svr.json  - Packer template for Jump Server and App Server
* web_svr.json - Packet template for the Web Server

### The conf subdirectory contains

* apache2.conf - The Apache2 configuration file with SSI enabled
* index.html - The home page for the Web Server
* web_svr.yml - The Ansible playbook to configure the Web Server
* ansible.cfg - Ansible configuration file
* hosts - hosts file for Ansible. Note use of ProxyCommand to jump through SSH Jump Server
* check.yml - Ansible playbook file for automated tests
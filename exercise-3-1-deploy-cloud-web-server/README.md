# Exercise 3-1 - Deploy a Cloud-Based Web Server

For this assignment I used Terraform to create a Web Server in AWS. The server is Apache2
with Server-Side Includes. The web page references an image stored in S3 and uses an SSI to 
display the output from ifconfig eth0. All server configuration is done via cloud-init
user-data. This is a second attempt where I used Terraforms file provisioner to upload
a pre-configured Apache2 configuration file, index.html along with an Ansible playbook.
I then used cloud-init to install Ansible and then run the playbook. Ansible performed the 
rest of the install and configuration of the Web Server.

There are three files in this directory

* README.md - This file
* main.tf - The Terraform file I used for this assignment
* screen-capture.png - Screen capture of the web page

The conf subdirectory contains

* apache2.conf - The Apache2 configuration file with SSI enabled
* index.html - The home page for the Web Server
* web_svr.yml - The Ansible playbook to configure the Web Server
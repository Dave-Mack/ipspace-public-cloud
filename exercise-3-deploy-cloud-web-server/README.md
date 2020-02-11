# Exercise 3 - Deploy a Cloud-Based Web Server

For this assignment I used Terraform to create a Web Server in AWS. The server is Apache2
with Server-Side Includes. The web page references an image stored in S3 and uses an SSI to 
display the output from ifconfig eth0. All server configuration is done via cloud-init
user-data. This was a pain, as I had to edit files in place from the shell. I definitely
see the advantage of server provisioning tools.

There are three files in this directory

* README.md - This file
* main.tf - The Terraform file I used for this assignment
* screen-capture.png - Screen capture of the web page
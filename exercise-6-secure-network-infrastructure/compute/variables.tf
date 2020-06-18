/******************************************************************************************
* This file defines the variables used for the Compute resources in this assignment       *
******************************************************************************************/

variable "allowed_ssh_prefixes_list" {
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "allowed_ssh_prefixes_ipv6list" {
  type = list(string)
  default = ["::/0"]
}

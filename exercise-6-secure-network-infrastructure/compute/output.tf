/******************************************************************************************
* This defines the outputs for Compute resources.                                         *
******************************************************************************************/

output "alb_dns_name" {
  value = aws_lb.web_svr_alb.dns_name
  description = "DNS Name of the Web Server ALB"
}

output "jump_server_dns_name" {
  value = aws_instance.jump_svr.public_dns
}

output "web_svr_private_ips" {
  value = "${data.aws_instances.web_svrs.private_ips}"
}

output "app_svr_private_ips" {
  value = "${data.aws_instances.app_svrs.private_ips}"
}

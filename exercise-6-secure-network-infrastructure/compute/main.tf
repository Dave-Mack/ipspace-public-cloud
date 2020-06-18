/******************************************************************************************
* This file implements compute resources after the network resouces have been created.    *
* A Terraform Remote State resouce is used to get required network variables as needed.   *
******************************************************************************************/

provider "aws" {
  region = "us-east-1"
}

# Use S3 as the backend for Terraform state

terraform {
  backend "s3" {
    bucket = "pubcloud-tf-state"
    key = "exercise6/compute/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-locks"
    encrypt = true
  }
}

# Data sources

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "pubcloud-tf-state"
    key = "exercise6/network/terraform.tfstate"
    region = "us-east-1"
  }
}


data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_instances" "web_svrs" {
  depends_on = [aws_autoscaling_group.web_svr_asg]
  instance_tags = {
    Name = "web-svr-asg"
  }
}

data "aws_instances" "app_svrs" {
  depends_on = [aws_autoscaling_group.app_svr_asg]
  instance_tags = {
    Name = "app-svr-asg"
  }
}

data "aws_iam_role" "cw_role" {
  name = "cw-role"
}

# Elastic IP Configuration for the SSH Jump Server

resource "aws_eip" "jump_eip" {
  vpc               = true
  network_interface = aws_network_interface.jump_eni.id
}

resource "aws_network_interface" "jump_eni" {
  subnet_id       = data.terraform_remote_state.network.outputs.public_subnet_1_id
  description     = "Public Subnet ENI for Jump Server"
  security_groups = [aws_security_group.jump_svr_sg.id]
}

# Security Groups

// Web Server Security Group
resource "aws_security_group" "web_svr_sg" {
  name   = "web-svr-sg"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.jump_svr.private_ip}/32"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    ipv6_cidr_blocks = formatlist("%s/128", aws_instance.jump_svr.ipv6_addresses)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}

// SSH Jump Server Security Group
resource "aws_security_group" "jump_svr_sg" {
  name   = "jump-svr-sg"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_prefixes_list
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    ipv6_cidr_blocks = var.allowed_ssh_prefixes_ipv6list
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}

// Application Server Security Group
resource "aws_security_group" "app_svr_sg" {
  name   = "app-svr-sg"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.network.outputs.public_subnet_1_cidr}", "${data.terraform_remote_state.network.outputs.public_subnet_2_cidr}" ]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.network.outputs.public_subnet_1_cidr}", "${data.terraform_remote_state.network.outputs.public_subnet_2_cidr}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.jump_svr.private_ip}/32"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    ipv6_cidr_blocks = ["${data.terraform_remote_state.network.outputs.public_subnet_1_ipv6_cidr}", "${data.terraform_remote_state.network.outputs.public_subnet_2_ipv6_cidr}" ]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    ipv6_cidr_blocks = ["${data.terraform_remote_state.network.outputs.public_subnet_1_ipv6_cidr}", "${data.terraform_remote_state.network.outputs.public_subnet_2_ipv6_cidr}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    ipv6_cidr_blocks = formatlist("%s/128", aws_instance.jump_svr.ipv6_addresses)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}

// Application Load Balancer Security Group
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Key for SSH Access to instances

resource "aws_key_pair" "aws_key" {
  key_name   = "aws_ssh_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9lyyleBFEUWdERyGALIuVxRUIIe90YUfx4xsXIcbWRV6nOwXHtOuZR4TodkVJQEQQpK0lKcEmZseDrjGdr0wz8l5yvt/vBVEt2uhujv5oR+Xux+FBmZ4olrrgv1b2Mji1WiUtSR4yHQSsceOXTr+mMu+lM8IQzuRtUqXjF8QMc9RwLkkhbfVzOSkVqXPByN7uNViF1kHA7KcA2wwXNv+lJxypyqqSV4PS4YpLqPIhKe4ajuakHwIO0ntUae1oBB8cgvP6GKKYwjpQEt8Nn8xEXeewRfDwlS+W2tZHLfjauaETYK29AAaxcKW50LRkpDTwM1QnVvVSAsultYVoOfORvHzBO42MUlYavIByFpLAZ64As49My8GS7AMLzusqNN6HG07XFZ6bBId/j117ECW3YDv2FnYYzrHoVl71CD/SqgppyvOonS/8cLtzY1y2rI+8E4CQkBJp5oDrqattNfzrWuAI0RiCNKKy7XMhM2xcjgxriF8gVwVICz9fij77GcjM1ozsE7KVQGoJgGtypTuU/Pyvm+jnBOKf4CaPgeQVomezsSB1buFy7N0I7Jo+Skqgrkhg4rellAKBMC8yfO+9WtsG6ZwtP8bELKpO8mIpGi5nkwf6gnVyPfIP/CXv1fCP4pcEjKVV3I7MhLQTNQ6qkXDIa4pqaZX0vlHjtCGqAw== mackd@acm.org"
}

# Auto Scaling Launch Configurations

resource "aws_launch_configuration" "web_svr" {
  image_id = "ami-0315fc87bd3bd6b33"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_svr_sg.id]
  key_name = "aws_ssh_key"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "app_svr" {
  image_id = "ami-029863637cc056154"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.app_svr_sg.id]
  key_name = "aws_ssh_key"

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Groups

resource "aws_autoscaling_group" "web_svr_asg" {
  launch_configuration = aws_launch_configuration.web_svr.name
  name = "web-svr-asg"
  min_size = 1
  max_size = 1
  vpc_zone_identifier = [ data.terraform_remote_state.network.outputs.public_subnet_1_id, data.terraform_remote_state.network.outputs.public_subnet_2_id ]
  target_group_arns = [ aws_lb_target_group.alb_tg.arn ]
  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "web-svr-asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "app_svr_asg" {
  launch_configuration = aws_launch_configuration.app_svr.name
  name = "app-svr-asg"
  min_size = 1
  max_size = 1
  vpc_zone_identifier = [ data.terraform_remote_state.network.outputs.public_subnet_1_id, data.terraform_remote_state.network.outputs.public_subnet_2_id ]

  tag {
    key = "Name"
    value = "app-svr-asg"
    propagate_at_launch = true
  }
}

# Instance Profile to assign the IAM Role required for CloudWatch access for the SSH Jump Server

resource "aws_iam_instance_profile" "cw_profile" {
  name = "cw-profile"
  role = data.aws_iam_role.cw_role.name
}

# Instance for the SSH Jump Server

resource "aws_instance" "jump_svr" {
  ami           = "ami-0181fac76793c50d1"
  instance_type = "t2.micro"
  key_name      = "aws_ssh_key"
  iam_instance_profile = aws_iam_instance_profile.cw_profile.name

  network_interface {
    network_interface_id = aws_network_interface.jump_eni.id
    device_index         = 0
  }
}

# Application Load Balancer Configuration

resource "aws_lb" "web_svr_alb" {
  name = "web-svr-alb"
  load_balancer_type = "application"
  subnets = [data.terraform_remote_state.network.outputs.public_subnet_1_id, data.terraform_remote_state.network.outputs.public_subnet_2_id]
  ip_address_type = "dualstack"
  security_groups = [aws_security_group.alb_sg.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_svr_alb.arn
  port = 80
  protocol = "HTTP"

   default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = 404
    }
  }
}

resource "aws_lb_listener_rule" "web_svr_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

    condition {
      path_pattern {
	values = ["*"]
      }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name = "web-svr-alb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
}

# Web Application Firewall Configuration

resource "aws_wafregional_regex_pattern_set" "priv_path_ps" {
  name = "priv-pattern-ps"
  regex_pattern_strings = ["/admin", "/login"]
}

resource "aws_wafregional_regex_match_set" "priv_path_ms" {
  name = "priv-path-ms"

  regex_match_tuple {
    field_to_match {
      type = "URI"
    }
    regex_pattern_set_id = aws_wafregional_regex_pattern_set.priv_path_ps.id
    text_transformation = "NONE"
  }
}

resource "aws_wafregional_rule" "priv_path_rule" {
  depends_on = [aws_wafregional_regex_match_set.priv_path_ms]
  name = "priv-path-rule"
  metric_name = "PrivPathRule"

  predicate {
    data_id = aws_wafregional_regex_match_set.priv_path_ms.id
    negated = false
    type = "RegexMatch"
  }
}

resource "aws_wafregional_web_acl" "web_svr_acl" {
  depends_on = [aws_wafregional_rule.priv_path_rule, aws_wafregional_regex_match_set.priv_path_ms]
  name = "web_svr_acl"
  metric_name = "WebSvrAcl"

  default_action {
    type = "ALLOW"
  }

  rule {
    action {
      type = "BLOCK"
    }
    priority = 1
    rule_id = aws_wafregional_rule.priv_path_rule.id
    type = "REGULAR"
  }
}

resource "aws_wafregional_web_acl_association" "web_svr_waf" {
  resource_arn = aws_lb.web_svr_alb.arn
  web_acl_id = aws_wafregional_web_acl.web_svr_acl.id
}


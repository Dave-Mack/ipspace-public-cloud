provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block                       = "172.16.0.0/16"
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = "172.16.1.0/24"
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 1)
  assign_ipv6_address_on_creation = true
}

resource "aws_subnet" "private_subnet" {
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = "172.16.2.0/24"
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 2)
  assign_ipv6_address_on_creation = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

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

resource "aws_route_table_association" "main_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "main_eip" {
  vpc               = true
  network_interface = aws_network_interface.main_eni.id
}

resource "aws_network_interface" "main_eni" {
  subnet_id       = aws_subnet.public_subnet.id
  description     = "Public Subnet ENI for Web Server"
  security_groups = [aws_security_group.web_svr_sg.id]
}

resource "aws_eip" "jump_eip" {
  vpc               = true
  network_interface = aws_network_interface.jump_eni.id
}

resource "aws_network_interface" "jump_eni" {
  subnet_id       = aws_subnet.public_subnet.id
  description     = "Public Subnet ENI for Jump Server"
  security_groups = [aws_security_group.jump_svr_sg.id]
}

resource "aws_security_group" "web_svr_sg" {
  name   = "web-svr-sg"
  vpc_id = aws_vpc.main.id

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
    from_port   = 22
    to_port     = 22
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

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_security_group" "jump_svr_sg" {
  name   = "jump-svr-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_key_pair" "aws_key" {
  key_name   = "aws_ssh_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9lyyleBFEUWdERyGALIuVxRUIIe90YUfx4xsXIcbWRV6nOwXHtOuZR4TodkVJQEQQpK0lKcEmZseDrjGdr0wz8l5yvt/vBVEt2uhujv5oR+Xux+FBmZ4olrrgv1b2Mji1WiUtSR4yHQSsceOXTr+mMu+lM8IQzuRtUqXjF8QMc9RwLkkhbfVzOSkVqXPByN7uNViF1kHA7KcA2wwXNv+lJxypyqqSV4PS4YpLqPIhKe4ajuakHwIO0ntUae1oBB8cgvP6GKKYwjpQEt8Nn8xEXeewRfDwlS+W2tZHLfjauaETYK29AAaxcKW50LRkpDTwM1QnVvVSAsultYVoOfORvHzBO42MUlYavIByFpLAZ64As49My8GS7AMLzusqNN6HG07XFZ6bBId/j117ECW3YDv2FnYYzrHoVl71CD/SqgppyvOonS/8cLtzY1y2rI+8E4CQkBJp5oDrqattNfzrWuAI0RiCNKKy7XMhM2xcjgxriF8gVwVICz9fij77GcjM1ozsE7KVQGoJgGtypTuU/Pyvm+jnBOKf4CaPgeQVomezsSB1buFy7N0I7Jo+Skqgrkhg4rellAKBMC8yfO+9WtsG6ZwtP8bELKpO8mIpGi5nkwf6gnVyPfIP/CXv1fCP4pcEjKVV3I7MhLQTNQ6qkXDIa4pqaZX0vlHjtCGqAw== mackd@acm.org"
}

resource "aws_instance" "web_svr" {
  ami           = "ami-0315fc87bd3bd6b33"
  instance_type = "t2.micro"
  #  vpc_security_group_ids = [aws_security_group.web_svr_sg.id]
  key_name = "aws_ssh_key"
  #  associate_public_ip_address = "true"
  #  subnet_id = aws_subnet.public_subnet.id

  network_interface {
    network_interface_id = aws_network_interface.main_eni.id
    device_index         = 0
  }
}


resource "aws_instance" "jump_svr" {
  ami           = "ami-029863637cc056154"
  instance_type = "t2.micro"
  key_name      = "aws_ssh_key"

  network_interface {
    network_interface_id = aws_network_interface.jump_eni.id
    device_index         = 0
  }
}

resource "aws_instance" "app_svr" {
  ami                    = "ami-029863637cc056154"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_svr_sg.id]
  key_name               = "aws_ssh_key"
  subnet_id              = aws_subnet.private_subnet.id
}



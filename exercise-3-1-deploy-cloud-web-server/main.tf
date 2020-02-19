provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "web_svr_sg" {
  name = "exercise3-web-svr-sg"
  
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
  
}

resource "aws_key_pair" "aws_key" {
  key_name = "aws_ssh_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9lyyleBFEUWdERyGALIuVxRUIIe90YUfx4xsXIcbWRV6nOwXHtOuZR4TodkVJQEQQpK0lKcEmZseDrjGdr0wz8l5yvt/vBVEt2uhujv5oR+Xux+FBmZ4olrrgv1b2Mji1WiUtSR4yHQSsceOXTr+mMu+lM8IQzuRtUqXjF8QMc9RwLkkhbfVzOSkVqXPByN7uNViF1kHA7KcA2wwXNv+lJxypyqqSV4PS4YpLqPIhKe4ajuakHwIO0ntUae1oBB8cgvP6GKKYwjpQEt8Nn8xEXeewRfDwlS+W2tZHLfjauaETYK29AAaxcKW50LRkpDTwM1QnVvVSAsultYVoOfORvHzBO42MUlYavIByFpLAZ64As49My8GS7AMLzusqNN6HG07XFZ6bBId/j117ECW3YDv2FnYYzrHoVl71CD/SqgppyvOonS/8cLtzY1y2rI+8E4CQkBJp5oDrqattNfzrWuAI0RiCNKKy7XMhM2xcjgxriF8gVwVICz9fij77GcjM1ozsE7KVQGoJgGtypTuU/Pyvm+jnBOKf4CaPgeQVomezsSB1buFy7N0I7Jo+Skqgrkhg4rellAKBMC8yfO+9WtsG6ZwtP8bELKpO8mIpGi5nkwf6gnVyPfIP/CXv1fCP4pcEjKVV3I7MhLQTNQ6qkXDIa4pqaZX0vlHjtCGqAw== mackd@acm.org"
}

resource "aws_instance" "simple" {
  ami = "ami-40d28157"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_svr_sg.id]
  key_name = "aws_ssh_key"
  associate_public_ip_address = "true"

  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file("/home/vagrant/.ssh/pub-cloud")
    }
  
  provisioner "remote-exec" {
    inline = [ "mkdir /tmp/ansible" ]
  }

  provisioner "file" {
    source="conf/apache2.conf"
    destination="/tmp/ansible/apache2.conf"
  }

  provisioner "file" {
    source="conf/index.html"
    destination="/tmp/ansible/index.html"
  }

  provisioner "file" {
    source="conf/web_svr.yml"
    destination="/tmp/ansible/web_svr.yml"
  }
     
  user_data = <<-EOF
#!/bin/bash
apt-get update
apt-get install ansible -y
ansible-playbook /tmp/ansible/web_svr.yml
EOF
  
  
}

  

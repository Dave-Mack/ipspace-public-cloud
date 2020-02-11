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

  user_data = <<-EOF
#!/bin/bash
apt-get update
apt -y install apache2
a2enmod include cgi
echo 'XBitHack On' >> /etc/apache2/apache2.conf
sed -i'' 's/Indexes FollowSymLinks/Indexes FollowSymLinks Includes/' /etc/apache2/apache2.conf
service apache2 restart
echo "<img src=http://pub-cloud.s3.amazonaws.com/AS_Network.jpeg style=\"width:800px;height:600px;\">" > /var/www/html/index.html
echo "<p>" >> /var/www/html/index.html
echo "<pre>" >> /var/www/html/index.html
echo '<!--#exec cmd="ifconfig eth0" -->' >> /var/www/html/index.html
echo "</pre>" >> /var/www/html/index.html
chmod +x /var/www/html/index.html
EOF
  
  
}

  

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "web-server-instance" {
  ami               = data.aws_ami.amazon-linux-2.id
  instance_type     = "t2.micro"
  key_name          = "MyKey"
  count = 2
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  associate_public_ip_address = true
}

resource "null_resource" "install_nginx_host1" {
  count = 2
  provisioner "remote-exec" {
    inline = [
      "echo 'Wait until SSH is ready'"
    ]
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/ansible/MyKey.pem")
    host        = aws_instance.web-server-instance[count.index].public_ip
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.web-server-instance[count.index].public_ip}, --private-key ~/ansible/MyKey.pem nginx.yaml"
  }
}

data "aws_ami" "amazon-linux-2" {
 most_recent = true


 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }


 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "instance_ip" {
  value = aws_instance.web-server-instance[*].public_ip
}
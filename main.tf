provider "aws" {
  region  = "eu-central-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
}

terraform {
  cloud {
    organization = "serg22"

    workspaces {
      name = "test"
    }
  }
}
resource "aws_security_group" "serg_sg" {
  name        = "OV_security"
  description = "Security group for the example application"

  ingress {
    from_port   = 80
    to_port     = 80
    self        = true
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "test" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.serg_sg.id]

  key_name = "aws_key"
  tags = {
    Name = "testKey"
  }
  user_data = <<-EOF
  #!/bin/bash
  sudo apt-get update
  sudo apt install docker.io -y
  sudo snap install docker
  sudo docker pull sergeygod/test:0.0.1
  sudo docker run -p 80:80 -d --restart unless-stopped --name test sergeygod/test:0.0.1
  sudo docker run -d --name watchtower --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower test --interval 60
  EOF

}

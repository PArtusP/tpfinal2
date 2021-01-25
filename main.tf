provider "aws" {
  region     = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "instance_jenkins_server_artus" {
  count         = var.create_instance ? var.instance_number : 0
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  public_key = var.key_pair

  tags = {
    Name = var.instance_name
  }
}

resource "aws_security_group" "security_group_jenkins_artus-web" {
  name = "security_group_jenkins_artus-web"

  ingress {
    description = "web from EC2"
    from_port   = 80
    to_port     = 80
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

resource "aws_security_group" "security_group_jenkins_artus-ssh" {
  name          = "security_group_jenkins_artus-ssh"

  ingress {
    description = "SSH from EC2"
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



terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

resource "aws_instance" "Minecraft_server" {
  ami           = "ami-05f9478b4deb8d173"
  instance_type = "t2.small"

security_group = [aws_security_group.minecraft_security_group.name]

user_data = file("minecraft_server_config.sh")

  tags = {
    Name = "Minecraft-Project-Server"
  }
}

resource "aws_eip" "minecraft_elastic_ip"{
  domain = "vpc"
}

resource "aws_eip_association" "minecraft_elastic_ip_association"{
  instance_id = aws_instance.Minecraft_server.id
  allocaton_id = aws_eip.minecraft_elastic_ip.id 
}

resource "aws_security_group" "minecraft_security_group"{
  name = "minecraft_security_group"
  description = "Minecraft security rules"

  ingress{
    from_port = 25565
    to_port = 25565
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}





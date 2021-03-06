terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>3.44.0"
        }
    }
}

# Configure the AWS Provider to build in the cloud
provider "aws" {
    profile = "default"
    region = var.aws_region
}

# Create a VPC
resource "aws_vpc" "schibes-demo-vpc" {
    tags = {
        Name = "schibes-demo-vpc"
    }
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = "true"
}

# Create Internet Gateway for the VPC
resource "aws_internet_gateway" "tf-gw" {
    vpc_id = aws_vpc.schibes-demo-vpc.id

    tags = {
        Name = "Terraform Internet Gateway"
    }
}

# Create subnet 1
resource "aws_subnet" "tf-primary" {
    vpc_id = aws_vpc.schibes-demo-vpc.id
    cidr_block = var.primary_subnet
    tags = {
        Name = "Primary"
    }
}

# Create subnet 2
resource "aws_subnet" "tf-secondary" {
    vpc_id = aws_vpc.schibes-demo-vpc.id
    cidr_block = var.secondary_subnet
    tags = {
        Name = "Secondary"
    }
}

# Create route table and associations
resource "aws_route_table" "tf-routes" {
    vpc_id = aws_vpc.schibes-demo-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.tf-gw.id
    }

    tags = {
        Name = "VPC Routes"
    }
}

resource "aws_route_table_association" "route-primary" {
  subnet_id      = aws_subnet.tf-primary.id
  route_table_id = aws_route_table.tf-routes.id
}

resource "aws_route_table_association" "route-secondary" {
  subnet_id      = aws_subnet.tf-secondary.id
  route_table_id = aws_route_table.tf-routes.id
}

#Create SG
resource "aws_security_group" "tf-instance-sg" {
    name = "tf-instance-sg"
    description = "Allow traffic to EC2 instances"
    vpc_id = aws_vpc.schibes-demo-vpc.id

    ingress {
        description      = "TLS"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
        description      = "SSH"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

}

# Create an EC2 instance in Primary subnet
resource "aws_instance" "tf-server1" {
    ami = var.ubuntu16_ami
    instance_type = "t2.micro"
    subnet_id = aws_subnet.tf-primary.id
    key_name = "schibes-ubuntu"
    associate_public_ip_address = "true"
    vpc_security_group_ids = [aws_security_group.tf-instance-sg.id]

    user_data = <<-EOF
            #!/bin/bash
            sudo apt -y update
            sudo apt install -y nginx
            cd /var/www/html
            sudo rm index.nginx-debian.html
            sudo wget https://raw.githubusercontent.com/Schibes/Schibes-cloudformation-demo/master/index.nginx-debian.html
            sudo systemctl enable nginx
            sudo systemctl restart nginx
            EOF

    tags = {
        Name = "Server 1"
    }
}


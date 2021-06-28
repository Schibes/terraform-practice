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
    region = "us-east-2"
}

# Create a VPC
resource "aws_vpc" "schibes-demo-vpc" {
    tags = {
        Name = "schibes-demo-vpc"
    }
    cidr_block = "10.70.0.0/16"
    enable_dns_hostnames = "true"
}

# Create subnet 1
resource "aws_subnet" "tf-primary" {
    vpc_id = aws_vpc.schibes-demo-vpc.id
    cidr_block = "10.70.100.0/24"
    tags = {
        Name = "Primary"
    }
}

# Create subnet 2
resource "aws_subnet" "tf-secondary" {
    vpc_id = aws_vpc.schibes-demo-vpc.id
    cidr_block = "10.70.200.0/24"
    tags = {
        Name = "Secondary"
    }
}

# Create an EC2 instance in Primary subnet
resource "aws_instance" "tf-server1" {
    ami = "ami-0d563aeddd4be7fff" #Ubuntu 16 in us-east-2
    instance_type = "t2.micro"
    subnet_id = aws_subnet.tf-primary.id
    key_name = "schibes-ubuntu"
    associate_public_ip_address = "true"
    tags = {
        Name = "Primary"
    }
}


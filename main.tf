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

# Create an EC2 instance
resource "aws_instance" "server1" {
    ami = "ami-02e30ba14d8ffa6e6" #Ubuntu 16 in us-east-2
    instance_type = "t2.micro"
    associate_public_ip_address = "true"
}
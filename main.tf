terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "3.1.0"
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
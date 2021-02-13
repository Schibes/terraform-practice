# Configure the AWS Provider to build in the cloud
provider "aws" {
    version = "~> 3.0"
    region = "us-east-2"
}

# Create a VPC
resource "aws_vpc" "schibes-demo-vpc" {
    tags = {
        Name = "schibes-demo-vpc"
    }
    cidr_block = "10.20.0.0/16"
    enable_dns_hostnames = "true"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


locals {
  username = "junechung"
  sample_var = "sample_var"
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
  profile = "2junechung"
}

# Create an EC2 
resource "aws_instance" "foo" {
  ami           = var.ami_string # us-west-2
  instance_type = "t2.micro"

 
  tags = var.ec2_tags
}

# separated to file but putting here to show local
output "check" {
  value = "helloworld-${local.username}"
}
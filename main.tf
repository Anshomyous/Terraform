terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}
// Povider details 
provider "aws" {
  region  = "us-east-1"
}
    // Creating VPC
resource "aws_vpc" "myapp_vpc" {
    cidr_block = var.vpc_cidr_block
    tags ={
        Name = "dev-vpc"
    }
  }
    // Creating subnet
  module "myapp-subnet" {
    source = "./modules/subnet"
    subnet_cidr_block = var.subnet_cidr_block
    vpc_id = var.vpc_id  
    // env = var.env
    avl_zone = var.avl_zone
    rt_id = var.rt_id
  }
    // defining ec2 instance variables
  module "myapp-webserver" {
    source = "./modules/web-server"
    vpc_id = var.vpc_id
    ip_adress = var.ip_adress 
    pub_key_location = var.pub_key_location
    avl_zone = var.avl_zone 
    subnet_id = module.myapp-subnet.subnet.id
    instance_type = var.instance_type 
  }
   
# terraform.tfvarsから取得するパラメータ
variable "allow_cidr_block" {}
variable "key_name" {}
variable "owner" {}
variable "ec2_ami_id" {}

provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = {
      System = local.name_prefix
      Owner  = var.owner
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
    }
  }
  required_version = "1.2.6"
  backend "s3" {
    # backend.confで設定
  }
}

module "vpc" {
  source      = "../modules/network/vpc"
  name_prefix = local.name_prefix
  cidr_block  = local.cidr_block
}

module "eip" {
  source      = "../modules/eip"
  name_prefix = local.name_prefix
}

module "subnet" {
  source                           = "../modules/network/subnet"
  name_prefix                      = local.name_prefix
  public_subnet_alb_2a_cidr_block  = local.public_subnet_alb_2a_cidr_block
  public_subnet_alb_2b_cidr_block  = local.public_subnet_alb_2b_cidr_block
  private_subnet_alb_2a_cidr_block = local.private_subnet_web_2a_cidr_block
  vpc_id                           = module.vpc.vpc_id
  subnet_az_2a                     = local.az_2a
  subnet_az_2b                     = local.az_2b
  eip_nat_2a_id                    = module.eip.eip_nat_2a_id
}

module "sg" {
  source           = "../modules/network/sg"
  name_prefix      = local.name_prefix
  vpc_id           = module.vpc.vpc_id
  allow_cidr_block = var.allow_cidr_block
}

module "ec2" {
  source            = "../modules/ec2"
  name_prefix       = local.name_prefix
  sg_id             = module.sg.sg_ec2_id
  subnet_id         = module.subnet.subnet_private_ec2_2a_id
  bastion_sg_id     = module.sg.sg_alb_id
  bastion_subnet_id = module.subnet.subnet_public_alb_2a_id
  key_name          = var.key_name
  ec2_ami_id        = var.ec2_ami_id
}

module "alb" {
  source              = "../modules/alb"
  subnet_az_2a_id     = module.subnet.subnet_public_alb_2a_id
  subnet_az_2b_id     = module.subnet.subnet_public_alb_2b_id
  sg_alb_id           = module.sg.sg_alb_id
  vpc_id              = module.vpc.vpc_id
  aws_instance_web_id = module.ec2.aws_instance_web_id
}
# terraform.tfvarsから取得するパラメータ
variable "allow_cidr_block" {}
variable "key_name" {}
variable "owner" {}

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
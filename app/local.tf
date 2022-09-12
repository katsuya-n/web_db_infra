locals {
  name_prefix                      = "lightkun-web-db-infra"
  cidr_block                       = "10.5.0.0/16"
  public_subnet_alb_2a_cidr_block  = "10.5.1.0/24"
  public_subnet_alb_2b_cidr_block  = "10.5.2.0/24"
  private_subnet_web_2a_cidr_block = "10.5.3.0/24"
  az_2a                            = "us-east-2a"
  az_2b                            = "us-east-2b"
}
##############################
# NETWORK
##############################
data "terraform_remote_state" "network_backstage" {
  backend = "s3"
  config = {
    bucket = var.backstage_ec2.network.bucket
    key    = var.backstage_ec2.network.key
    region = var.backstage_ec2.network.region
  }
}

locals {
  vpc_id    = data.terraform_remote_state.network_backstage.outputs.network.vpc_id
  subnet_id = data.terraform_remote_state.network_backstage.outputs.network.public_subnets[0]
}

##############################
# BACKSTAGE
##############################
resource "random_string" "random_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_kms_key" "this" {}

resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "key_pair_external" {
  source     = "terraform-aws-modules/key-pair/aws"
  key_name   = "backstage-external-${random_string.random_suffix.result}"
  public_key = trimspace(tls_private_key.this.public_key_openssh)
}

module "security_group_backstage" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "~> 4.0"
  name                = var.backstage_ec2.security_group.name
  description         = var.backstage_ec2.security_group.description
  vpc_id              = local.vpc_id
  ingress_cidr_blocks = var.backstage_ec2.security_group.ingress_cidr_blocks
  ingress_rules       = var.backstage_ec2.security_group.ingress_rules
  egress_rules        = var.backstage_ec2.security_group.egress_rules
  tags                = var.backstage_ec2.security_group.tags
}

resource "aws_eip" "lb" {
  instance = module.ec2_backstage.id
  domain   = "vpc"
}

module "ec2_backstage" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = var.backstage_ec2.name
  ami                    = var.backstage_ec2.ami
  instance_type          = var.backstage_ec2.instance_type
  availability_zone      = var.backstage_ec2.availability_zone
  subnet_id              = local.subnet_id
  vpc_security_group_ids = [module.security_group_backstage.security_group_id]
  enable_volume_tags     = false
  key_name               = module.key_pair_external.key_pair_name
  root_block_device      = var.backstage_ec2.root_block_device
  user_data              = var.backstage_ec2.user_data
}

output "backstage-ssh-key" {
  value     = tls_private_key.this.private_key_pem
  sensitive = true
}

resource "local_file" "backstage-ssh-key" {
  content         = tls_private_key.this.private_key_pem
  filename        = "backstage/backstage_private_key.pem"
  file_permission = "600"
}

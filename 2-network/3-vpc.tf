module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                   = var.vpc_default.name
  cidr                   = var.vpc_default.cidr
  azs                    = var.vpc_default.azs
  private_subnets        = var.vpc_default.private_subnets
  public_subnets         = var.vpc_default.public_subnets
  enable_nat_gateway     = var.vpc_default.enable_nat_gateway
  single_nat_gateway     = var.vpc_default.single_nat_gateway
  one_nat_gateway_per_az = var.vpc_default.one_nat_gateway_per_az
  tags                   = var.vpc_default.tags
}

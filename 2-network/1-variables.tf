variable "vpc_default" {
  default = {
    name                   = "backstage-demo-vpc"
    cidr                   = "10.0.0.0/16"
    azs                    = ["ap-southeast-1a"]
    private_subnets        = ["10.0.1.0/24"]
    public_subnets         = ["10.0.101.0/24"]
    enable_nat_gateway     = false
    single_nat_gateway     = false
    one_nat_gateway_per_az = true
    tags = {
      project_code = "backstage"
    }
  }
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket  = "backstage-archive"
    key     = "states/1-bootstrap/terraform.tfstate"
    region  = "ap-southeast-1"
    encrypt = true
  }
}

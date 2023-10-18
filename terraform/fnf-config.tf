# provider aws
provider "aws" {
  region = "us-east-1"
}

# configuracao terraform
terraform {
  required_version = ">=1.0"

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.69.0"
    }
  }
}
// aws provider configuration
provider "aws" {
  region = "us-east-1"
  profile = "tf-user"
}

// terraform configuration
terraform {
  required_version = ">=1.0"
  
  //infra for terraform backend state 
  backend "s3" {
    bucket  = "fnf-terraform"
    key     = "fnf-terraform.tfstate"
    region  = "us-east-1"
    profile = "tf-user"
  }

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.69.0"
    }
  }
}
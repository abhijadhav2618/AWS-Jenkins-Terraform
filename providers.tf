terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "s3-bucket-for-practice-terraform-18-05-2002"
    key = "stateFiles"
    region = "us-east-1"
    # use_lockfile = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  shared_credentials_files = ["C:/.aws/credentials"]
  
}

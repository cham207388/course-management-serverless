terraform {

  required_version = "~> 1.7" // present 1.7.5 allows 1.7.x 1.8, 1.8

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" // current version 5.42.0
    }
  }

  backend "s3" {
    bucket         = "project-terraform-state-abc"
    key            = "course-management/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "project-terraform-state-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}

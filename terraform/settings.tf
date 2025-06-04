terraform {

  required_version = "~> 1.7" // present 1.7.5 allows 1.7.x 1.8, 1.8

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.42" # Pinned to latest stable 5.x version
    }
    # api-gateway-enable-cors = {
    #   source  = "squidfunk/api-gateway-enable-cors"
    #   version = "~> 0.3" # For CORS module
    # }
  }

  backend "s3" {
    bucket       = "project-terraform-state-abc"
    key          = "course-management/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}

# provider "api-gateway-enable-cors" {}
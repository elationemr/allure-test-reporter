terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
    random = {
      source = "hashicorp/random"
    }
  }

  backend "remote" {
    organization = "elation"

    workspaces {
      prefix = "allure-test-reporter-"
    }
  }
}

provider "aws" {
  region = local.workspace.region
}

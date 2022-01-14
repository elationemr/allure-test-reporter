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
      prefix = "insurance-api_"
    }
  }
}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${local.aws_account_id}:role/${local.workspace.environment}-${local.service_key}-automation-role"
  }
}

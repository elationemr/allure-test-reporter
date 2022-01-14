# This is passed in via a terraform workspace configured variable/
# It is a known issue that GH actions has trouble passing runtime
# vars into TF when using a provider prefix.
variable "environment" {
  type = string
}

variable "cluster" {
  type = string
}

variable "project" {
  type = string
}

variable "service_key" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "region" {
  type = string
}

locals {

  # If this became standardized for microservices, we could read this type of 
  # config from yml files that match an expected format. Teams could provision
  # an "ECS Container" microservice type and configure their expected variables
  # via that yml file so they never have to touch terraform except in advanced
  # cases. 
  # i.e.
  # instance_size = _
  # instance_count = _
  # project = _
  # cluster_name = _

  project        = var.project
  service_key    = var.service_key
  aws_account_id = var.aws_account_id

  env = {
    defaults = {
      project               = var.project
      environment           = var.environment
      region                = var.region
      cluster               = var.cluster
      aws_account_id        = var.aws_account_id
      environment_short_tag = var.environment
    }
  }

  default_tags = {
    project     = var.project
    environment = var.environment
    terraform   = true
  }


  workspaces = {
    dev = {
      desired_tasks   = 1
      vpc_id          = "vpc-00a821dea00fbceaa"
      public_subnets  = ["subnet-0067798050ea6a3c1", "subnet-0fffac7c43c862b6d", "subnet-0aa7740ab1d71c27a"] # el8-dev-public 1,2,3
      private_subnets = ["subnet-03e17b0310aa4978b", "subnet-0de20c7cd6fa93cd2", "subnet-0bad51598c09f1380"] # el8-dev-private 1,2,3
      private_sg_id   = "sg-0cc83447363369cc7"
    }
    # we don't want this deployed to environments above dev
  }

  workspace = merge(local.env.defaults, lookup(
    local.workspaces,
    var.environment,
    local.workspaces.dev
  ))
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  cloud {
    organization = "Knaz"

    workspaces {
      name = "aws-pet-reminderapp"
    }
  }
}

variable "access" {

}
variable "secret" {

}

variable "token" {

}
provider "aws" {
  region     = "us-east-1"
  access_key = var.access
  secret_key = var.secret
  token      = var.token
}

module "ses_email" {
  source = "./modules/pet-reminder-app"
}
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




provider "aws" {
  region     = "us-east-1"
  access_key = var.access
  secret_key = var.secret
  token      = var.token
}

module "ses_email" {
  source = "./modules/pet-reminder-app"
  accountId = var.accountId
  }

output "pet_lambda_arn" {
  value = module.ses_email.lambda_arn
}

output "pet_state_machine_arn" {
  value = module.ses_email.pet_state_machine_arn

}

output "apigw_invoke_url" {
  value = module.ses_email.apigw_invoke_url

}

output "lambda_permission_source_arn" {
  value = module.ses_email.lambda_permission_source_arn
}



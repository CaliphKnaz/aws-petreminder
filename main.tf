terraform {
  cloud {
    organization = "Knaz"

    workspaces {
      name = "aws-pet-reminderapp"
    }
  }
}

module "ses_email" {
  source = "./modules/pet-reminder-app"
}
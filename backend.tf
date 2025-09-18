// backend.tf
terraform {
  cloud {
    organization = "inova7cloud"

    workspaces {
      name = "azure-lab"
      // For Terraform Enterprise, add: hostname = "tfe.yourcompany.com"
    }
  }

  required_version = ">= 1.6.0"
}


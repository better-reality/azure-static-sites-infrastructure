# Hashicorp strongly recommend using this required_providers block to set the
# Azure Provider source and version being used
terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.99.0"
    }
  }
}

# Azure Provider Configuration
provider "azurerm" {
  features {}
}


module "yellow_initiative" {
  source = "./modules/static-web-site"

  site_rg_name              = "betterRealityMmainRG"
  site_rg_location          = "westus"
  site_storage_account_name = "yellowinitfsdjkl3s"
}

output "website_url" {
  description = "Yellow initiative website url"
  value       = module.yellow_initiative.website_url
}

output "connection_string" {
  description = "Yellow initiative storage connection string"
  value       = module.yellow_initiative.connection_string
  sensitive   = true
}
# Hashicorp strongly recommend using this required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-backend"
    storage_account_name = "trbacyeskendmxph9tim"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}

# Azure Provider Configuration
provider "azurerm" {
    features {}
    skip_provider_registration = true

    client_id       = "cbfcddc0-f653-4a43-aef3-425cddc24342"
    client_secret   = "ijN8Q~j4S_pjWKA2gkQOPROVxQFj2.7MPotUhaoi"
    tenant_id       = "2d22b31e-ed37-44d7-a0f0-c2214b9f04a9"
    subscription_id = "a02551c6-4b77-40a3-b32f-0218724239b1"

}

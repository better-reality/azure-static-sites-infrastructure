# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Azure Provider Configuration
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Configure Azure Resource Group for Terraform Backend
resource "azurerm_resource_group" "tf_backend_rg" {
  # Name and location of the resource group
  name     = var.resource_group_name
  location = var.location
}

# Generate a random string to use as part of the storage account name
resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false

  # This 'keeper' field forces a new random string to be generated each
  # time the workspace changes. Since the workspace doesn't really change
  # during the same use, this will effectively keep the same random string.
  keepers = {
    workspace_name = terraform.workspace
  }
}

# Create Azure Storage Account for Terraform Backend
resource "azurerm_storage_account" "tf_backend_storage_account" {
  # Storage account name, and specify the resource group and location it should be part of
  name                = "${var.storage_account_name}${random_string.random.result}"
  resource_group_name = azurerm_resource_group.tf_backend_rg.name
  location            = azurerm_resource_group.tf_backend_rg.location
  # Account tier and replication type
  account_tier             = "Standard"
  account_replication_type = "LRS"
  # Tag the resource
  tags = {
    environment = var.environment
  }

  depends_on = [random_string.random, azurerm_resource_group.tf_backend_rg]
}

# Create Azure Storage Container for Terraform State
resource "azurerm_storage_container" "tf_state_container" {
  # Name of the storage container and the storage account it should be part of
  name                 = "terraform-state"
  storage_account_name = azurerm_storage_account.tf_backend_storage_account.name
  # The visibility and access rule for the blob. 'private' means no public access
  container_access_type = "private"
}

# Output for the primary storage account key for the Terraform Backend
# This key will be used by Terraform to authenticate with the Azure Storage Account
# Marking it as 'sensitive' ensures it is not displayed in the console output
output "terraform_backend_primary_access_key" {
  value       = azurerm_storage_account.tf_backend_storage_account.primary_access_key
  sensitive   = true
  description = "Primary access key for the Azure Storage Account that is used as a backend for Terraform. Should be treated as sensitive and not displayed in logs or console output."
}

# Output for the ID of the Azure Storage Account that will be used as the Terraform Backend
# This identifier will be used for all Terraform Backend operations
output "terraform_backend_storage_account_id" {
  value       = azurerm_storage_account.tf_backend_storage_account.id
  description = "ID of the Azure Storage Account that is used as a backend for Terraform."
}

# Output for the name of the Azure Resource Group where the Azure Storage Account for the Terraform Backend is located
# This information is needed for Terraform to know where the backend infrastructure is locate
output "terraform_backend_resource_group_name" {
  value       = azurerm_resource_group.tf_backend_rg.name
  description = "Name of the Resource Group where the Azure Storage Account (Terraform Backend) is located."
}

# Output for the name of the Azure Storage Container where the Terraform state will be stored
# This information is used by Terraform to know where to store its state files
output "terraform_backend_state_container_name" {
  value       = azurerm_storage_container.tf_state_container.name
  description = "Name of the Azure Storage Container where the Terraform state files are stored."
}
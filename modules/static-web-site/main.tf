variable "site_rg_name" {
  type        = string
  description = "The name of the resource group that will contain the resources for the static website."

}

variable "site_rg_location" {
  type = string
  description = "The location where the resource group for the static website will be created."
  default = "westus"
}

variable "site_storage_account_name" {
  type        = string
  description = "The name of the storage account for the static website."
}


resource "azurerm_resource_group" "rg" {
  name     = var.site_rg_name
  location = var.site_rg_location
}

resource "azurerm_storage_account" "sa" {
  name                     = var.site_storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}

resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${path.module}/index.html"
  content_type           = "text/html"
}

resource "azurerm_storage_blob" "error" {
  name                   = "404.html"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${path.module}/404.html"
  content_type           = "text/html"
}


# Output Website URL
output "website_url" {
  value = "https://${azurerm_storage_account.sa.primary_web_host}"
}

output "connection_string" {
  value = azurerm_storage_account.sa.primary_connection_string
  sensitive = true
}


resource "local_file" "azure_storage_connection_string" {
  content  = azurerm_storage_account.sa.primary_connection_string
  filename = "${path.root}/secrets/AZURE_STORAGE_CONNECTION_STRING_${azurerm_storage_account.sa.name}.txt"
}
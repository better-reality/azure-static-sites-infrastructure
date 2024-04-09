variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-terraform-backend"
}

variable "location" {
  description = "The location/region in which to create the resources"
  type        = string
  default     = "westeurope"
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
  default     = "trbacyeskend"
}

variable "environment" {
  description = "The environment tag for the resources"
  type        = string
  default     = "terraform"
}
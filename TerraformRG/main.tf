provider "azurerm" {
  features {}
}
terraform {
  backend "azurerm" {
    storage_account_name = "storage9833"
    container_name       = "terraformstate"
    key                  = "test.terraform.tfstate"

    # rather than defining this inline, the Access Key can also be sourced
    # from an Environment Variable - more information is available below.
    access_key = "NnwSrGw0r8hoHDBLsAtDQ0Kh4bB/j0EiKJ69Kcop3mzV2Nfh52PWX1wXCVEo7qRzqmptgaPR2lZZ03XG1HTw9Q=="
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "ATT_GROUPTestState"
  location = "South India"
}

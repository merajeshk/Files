#resource "random_pet" "prefix" {}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "akscluster-rg"
  location = "southindia"

  tags = {
    environment = "Demo"
  }
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "akscluster-aks"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "akscluster-k8s"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "standard_d11"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  #role_based_access_control {
    #enabled = true
  #}

  tags = {
    environment = "Demo"
  }
}
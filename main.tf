provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "ATT_GROUPTest"
  location = "South India"
}

resource "azurerm_virtual_network" "vn" {
  name                = "ATT_VNT"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "sn" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_public_ip" "pi" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}
resource "azurerm_network_interface" "ni" {
  name                = "ATT_nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sn.id
    #private_ip_address_allocation = "Dynamic"
	public_ip_address_id 		  = azurerm_public_ip.pi.id
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = "TerraformVM"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_DS1"
  admin_username      = "tfuser"
  admin_password      = "Welcome@123"
  network_interface_ids = [
    azurerm_network_interface.ni.id,
  ]


  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "win10-21h2-pro-g2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}
variable "storage_account_name" {
    type=string
    default="az400terraform120522"
}
 
variable "network_name" {
    type=string
    default="staging2"
}
 
variable "vm_name" {
    type=string
    default="ubuntu-terraform-vm"
}
 
provider "azurerm"{
version = "=2.0"
subscription_id = "2bc6e5ee-4850-4548-9882-b2b5ed8b51d4"
tenant_id       = "6b40ad34-f068-4b18-80e5-6f2ff666121c"
features {}
}
 
resource "azurerm_virtual_network" "staging2" {
  name                = var.network_name
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = "arm-iac"
}
 
resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = "arm-iac"
  virtual_network_name = azurerm_virtual_network.staging2.name
  address_prefix     = "10.0.0.0/24"
}
 
resource "azurerm_network_interface" "interface" {
  name                = "default-interface"
  location            = "East US"
  resource_group_name = "arm-iac"
 
  ip_configuration {
    name                          = "interfaceconfiguration"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
  }
}
 
resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = "East US"
  resource_group_name   = "arm-iac"
  network_interface_ids = [azurerm_network_interface.interface.id]
  vm_size               = "Standard_DS1_v2"
 
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "ubuntu-terraform-vm"
    admin_username = "makarand"
    admin_password = "makarand@1234"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }  
}

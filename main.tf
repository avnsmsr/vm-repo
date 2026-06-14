resource "azurerm_resource_group" "RG_santu" {
  for_each = var.RG_santu
  name     = each.value.name
  location = each.value.location
}
variable "RG_santu" {
  type = map(any)
}

variable "vnet" {
  type = map(any)

}


resource "azurerm_virtual_network" "vnet" {
  for_each            = var.vnet
  name                = each.value.name
  location            = each.value.location
  resource_group_name = azurerm_resource_group.RG_santu[each.value.resource_group_name].name
  address_space       = each.value.address_space
}

variable "subnet" {
  type = map(any)

}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnet
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.RG_santu[each.value.resource_group_name].name
  virtual_network_name = azurerm_virtual_network.vnet[each.value.virtual_network_name].name
  address_prefixes     = ["10.0.1.0/24"]
}


variable "nic" {
  type = map(any)
}

resource "azurerm_network_interface" "nic" {
  for_each            = var.nic
  name                = each.value.name
  location            = each.value.location
  resource_group_name = azurerm_resource_group.RG_santu[each.value.resource_group_name].name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet[each.value.subnet_key].id
    private_ip_address_allocation = "Dynamic"
  }
}

variable "vm" {
  type = map(any)

}

resource "azurerm_linux_virtual_machine" "frontend-vm" {
    for_each = var.vm
  name                = each.value.name
  resource_group_name =  azurerm_resource_group.RG_santu[each.value.resource_group_name].name
  location            = each.value.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  network_interface_ids = [azurerm_network_interface.nic[each.value.nic_key].id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

variable "nsg" {
  type = map(any)

}

resource "azurerm_network_security_group" "nsg" {
  for_each = var.nsg
  name                = each.value.name
  location            = azurerm_resource_group.RG_santu[each.value.resource_group_name].location
  resource_group_name = azurerm_resource_group.RG_santu[each.value.resource_group_name].name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  } 
}


resource "azurerm_virtual_network_peering" "test_to_test1" {

  name = "test-to-test1"

  resource_group_name = azurerm_resource_group.RG_santu["test"].name

  virtual_network_name = azurerm_virtual_network.vnet["test"].name

  remote_virtual_network_id = azurerm_virtual_network.vnet["test1"].id

  allow_virtual_network_access = true

}


resource "azurerm_virtual_network_peering" "test1_to_test" {

  name = "test1-to-test"

  resource_group_name = azurerm_resource_group.RG_santu["test"].name

  virtual_network_name = azurerm_virtual_network.vnet["test1"].name

  remote_virtual_network_id = azurerm_virtual_network.vnet["test"].id

  allow_virtual_network_access = true

}
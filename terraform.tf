RG_santu = {
  test = {
    name     = "rg-santutest"
    location = "centralindia"
  }
}

vnet = {
  test = {
    name                = "vnet-webtest"
    location            = "centralindia"
    resource_group_name = "test"
    address_space       = ["10.0.0.0/16"]
  }
  test1 = {
    name                = "vnet1-webtest"
    location            = "centralindia"
    resource_group_name = "test"
    address_space       = ["10.1.0.0/16"]
  }
}

subnet = {
  test = {
    name                 = "subnet-webtest"
    virtual_network_name = "test"
    resource_group_name  = "test"
    location             = "centralindia"
  }
}

nic = {
  test = {
    name                = "nic-webtest"
    location            = "centralindia"
    resource_group_name = "test"
    subnet_key          = "test"
  }
}

vm = {
  test = {
    name                = "vm-webtest"
    location            = "centralindia"
    resource_group_name = "test"
    size                = "Standard_DS1_v2"
    admin_username      = "azureuser"
    admin_password      = "P@ssw0rd1234!"
    nic_key             = "test"
  }
}

nsg = {
  test = {
    name                = "nsg-webtest"
    location            = "centralindia"
    resource_group_name = "test"
  }
}
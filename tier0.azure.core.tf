resource "azurerm_resource_group" "azure-core" {
   name         = "azure-core"
   location     = "${var.loc}"
   tags         = "${var.tags}"
}

resource "azurerm_virtual_network" "azure-hub" {
  name                = "azure-hub"
  resource_group_name = "${azurerm_resource_group.azure-core.name}"
  location            = "${azurerm_resource_group.azure-core.location}"
  address_space       = ["192.168.0.0/16"]
  tags                 = "${azurerm_resource_group.azure-core.tags}"
}

resource "azurerm_subnet" "GatewaySubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = "${azurerm_resource_group.azure-core.name}"
  virtual_network_name = "${azurerm_virtual_network.azure-hub.name}"
  address_prefix       = "192.168.0.0/24"
}

resource "azurerm_subnet" "jump" {
  name                 = "jump"
  resource_group_name  = "${azurerm_resource_group.azure-core.name}"
  virtual_network_name = "${azurerm_virtual_network.azure-hub.name}"
  address_prefix       = "192.168.1.0/24"
}

resource "azurerm_subnet" "management" {
  name                 = "management"
  resource_group_name  = "${azurerm_resource_group.azure-core.name}"
  virtual_network_name = "${azurerm_virtual_network.azure-core.name}"
  address_prefix       = "192.168.2.0/24"
}

resource "azurerm_virtual_network" "azure-spoke" {
  name                = "azure-spoke"
  resource_group_name = "${azurerm_resource_group.azure-core.name}"
  location            = "${azurerm_resource_group.azure-core.location}"
  address_space       = ["192.168.1.0/16"]
  tags                 = "${azurerm_resource_group.azure-core.tags}"
}
resource "azurerm_public_ip" "vpnGatewayPublicIp" {
  name                    = "vpnGatewayPublicIp"
  location                = "${azurerm_resource_group.azure-core.location}"
  resource_group_name     = "${azurerm_resource_group.azure-core.name}"
  allocation_method       = "Dynamic"

  tags                    = "${azurerm_resource_group.azure-core.tags}"
}

/*resource "azurerm_virtual_network_gateway" "vpnGateway" {
  name                = "vpnGateway"
  location            = "${azurerm_resource_group.azure-core.location}"
  resource_group_name = "${azurerm_resource_group.azure-core.name}"

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "Basic"

  ip_configuration {
    name                          = "vpnGwConfig1"
    public_ip_address_id          = "${azurerm_public_ip.vpnGatewayPublicIp.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_subnet.GatewaySubnet.id}"
  }

} */
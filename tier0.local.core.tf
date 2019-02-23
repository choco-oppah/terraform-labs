resource "azurerm_resource_group" "local-core" {
   name         = "local-core"
   location     = "${var.loc}"
   tags         = "${var.tags}"
}

resource "azurerm_virtual_network" "local-core" {
  name                = "local-core"
  resource_group_name = "${azurerm_resource_group.local-core.name}"
  location            = "${azurerm_resource_group.local-core.location}"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["1.1.1.1", "1.0.0.1"]
  tags                 = "${azurerm_resource_group.local-core.tags}"
}

resource "azurerm_subnet" "GatewaySubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = "${azurerm_resource_group.local-core.name}"
  virtual_network_name = "${azurerm_virtual_network.local-core.name}"
  address_prefix       = "10.0.0.0/24"
}

resource "azurerm_subnet" "training" {
  name                 = "training"
  resource_group_name  = "${azurerm_resource_group.local-core.name}"
  virtual_network_name = "${azurerm_virtual_network.local-core.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_subnet" "dev" {
  name                 = "dev"
  resource_group_name  = "${azurerm_resource_group.local-core.name}"
  virtual_network_name = "${azurerm_virtual_network.local-core.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "vpnGatewayPublicIp" {
  name                    = "vpnGatewayPublicIp"
  location                = "${azurerm_resource_group.local-core.location}"
  resource_group_name     = "${azurerm_resource_group.local-core.name}"
  allocation_method       = "Dynamic"

  tags                    = "${azurerm_resource_group.local-core.tags}"
}

/*resource "azurerm_virtual_network_gateway" "vpnGateway" {
  name                = "vpnGateway"
  location            = "${azurerm_resource_group.local-core.location}"
  resource_group_name = "${azurerm_resource_group.local-core.name}"

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
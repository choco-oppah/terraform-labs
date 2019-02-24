resource "azurerm_resource_group" "azure-core" {
   name         = "azure-core"
   location     = "${var.loc}"
   tags         = "${var.tags}"
}

resource "azurerm_virtual_network" "azure-hub" {
  name                = "azure-hub"
  resource_group_name = "${azurerm_resource_group.azure-core.name}"
  location            = "${azurerm_resource_group.azure-core.location}"
  address_space       = ["192.168.0.0/18"]
  tags                 = "${azurerm_resource_group.azure-core.tags}"
    subnet {
      name                 = "GatewaySubnet"
      address_prefix       = "192.168.0.0/24"
    }

    subnet {
      name                 = "jump"
      address_prefix       = "192.168.1.0/24"
    }

    subnet {
      name                 = "management"
      address_prefix       = "192.168.2.0/24"
    }
}
resource "azurerm_virtual_network" "azure-spoke" {
  name                = "azure-spoke"
  resource_group_name = "${azurerm_resource_group.azure-core.name}"
  location            = "${azurerm_resource_group.azure-core.location}"
  address_space       = ["192.168.64.0/18"]
  tags                 = "${azurerm_resource_group.azure-core.tags}"

    subnet {
      name                 = "GatewaySubnet"
      address_prefix       = "192.168.64.0/24"
    }

    subnet {
      name                 = "virtualmachine"
      address_prefix       = "192.168.65.0/24"
    }

}
resource "azurerm_virtual_network_peering" "hub" {
  name                      = "hubtospoke"
  resource_group_name       = "${azurerm_resource_group.azure-core.name}"
  virtual_network_name      = "${azurerm_virtual_network.azure-hub.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.azure-spoke.id}"
  allow_gateway_transit     = true
}

resource "azurerm_virtual_network_peering" "spoke" {
  name                      = "spoketohub"
  resource_group_name       = "${azurerm_resource_group.azure-core.name}"
  virtual_network_name      = "${azurerm_virtual_network.azure-spoke.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.azure-hub.id}"
  allow_virtual_network_access  = true
  /*use_remote_gateways       = true*/
}

resource "azurerm_public_ip" "azure-vpnGatewayPublicIp" {
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
variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

resource "azurerm_resource_group" "hub" {
  name     = "hub"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "hub" {
  name                = "tfc-hub-vnet-${random_string.suffix.result}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = ["10.10.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "private_endpoint" {
  name                                           = "snet-private-endpoint"
  resource_group_name                            = azurerm_resource_group.hub.name
  virtual_network_name                           = azurerm_virtual_network.hub.name
  address_prefixes                               = ["10.10.1.0/24"]
  private_endpoint_network_policies_enabled      = false
  private_link_service_network_policies_enabled  = false
}

resource "azurerm_eventhub_namespace" "hub" {
  name                = "tfc-hub-evh-${random_string.suffix.result}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  sku                 = "Standard"
  capacity            = 1
  tags                = var.tags
}

resource "azurerm_eventhub" "hub" {
  name                = "tfc-hub-${random_string.suffix.result}"
  namespace_name      = azurerm_eventhub_namespace.hub.name
  resource_group_name = azurerm_resource_group.hub.name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_private_dns_zone" "servicebus" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = azurerm_resource_group.hub.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "servicebus" {
  name                  = "tfc-hub-svcbus-link"
  resource_group_name   = azurerm_resource_group.hub.name
  private_dns_zone_name = azurerm_private_dns_zone.servicebus.name
  virtual_network_id    = azurerm_virtual_network.hub.id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_endpoint" "eventhub" {
  name                = "tfc-hub-evh-pe-${random_string.suffix.result}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  subnet_id           = azurerm_subnet.private_endpoint.id
  tags                = var.tags

  private_service_connection {
    name                           = "tfc-hub-evh-connection"
    private_connection_resource_id = azurerm_eventhub_namespace.hub.id
    subresource_names              = ["namespace"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "servicebus"
    private_dns_zone_ids = [azurerm_private_dns_zone.servicebus.id]
  }
}

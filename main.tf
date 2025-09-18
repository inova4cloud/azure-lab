locals {
  location = "eastus"
  tags = {
    environment = "lab"
  }
}

module "hub" {
  source   = "./modules/hub"
  location = local.location
  tags     = local.tags
}

output "eventhub_namespace_name" {
  description = "Name of the private Event Hub namespace"
  value       = module.hub.eventhub_namespace_name
}

output "private_endpoint_ip" {
  description = "Private IP address assigned to the Event Hub private endpoint"
  value       = module.hub.private_endpoint_ip
}

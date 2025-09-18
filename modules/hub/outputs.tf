output "eventhub_namespace_name" {
  description = "Name of the private Event Hub namespace"
  value       = azurerm_eventhub_namespace.hub.name
}

output "private_endpoint_ip" {
  description = "Private IP address assigned to the Event Hub private endpoint"
  value       = azurerm_private_endpoint.eventhub.private_service_connection[0].private_ip_address
}

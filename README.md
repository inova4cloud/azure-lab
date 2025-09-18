# Azure Private Event Hub Lab

This Terraform configuration provisions an Azure Event Hubs namespace that is only reachable through a private endpoint.  The deployment creates the following resources:

- A resource group in Azure for all lab assets.
- A virtual network with a dedicated subnet for private endpoints.
- An Event Hubs namespace and a sample Event Hub.
- A Private DNS zone for the `privatelink.servicebus.windows.net` domain and a link to the virtual network.
- A Private Endpoint that exposes the Event Hubs namespace inside the virtual network.

## Usage

1. Authenticate with Azure (for example using `az login`).
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Review the execution plan:
   ```bash
   terraform plan
   ```
4. Apply the configuration:
   ```bash
   terraform apply
   ```

After the apply completes Terraform will output the Event Hubs namespace name and the private IP address assigned to the private endpoint.

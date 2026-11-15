resource "azurerm_resource_group" "lab" {
  name     = "rg-az305-storage-lab"
  location = "northeurope"

  tags = {
    environment = "lab"
    project     = "az305"
    managedBy   = "terraform"
  }
}

resource "azurerm_storage_account" "lab" {
  name                = "staz305la1589sa"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false

  tags = azurerm_resource_group.lab.tags

  # For production, prefer Entra ID and Managed Identities, 
  # disable Shared Key authorization where supported, 
  # and issue short-lived user delegation SAS tokens when delegation is necessary.
  # shared_access_key_enabled = false
}

resource "azurerm_storage_container" "lab" {
  name                  = "audit-exports"
  storage_account_id    = azurerm_storage_account.lab.id
  container_access_type = "private"
}
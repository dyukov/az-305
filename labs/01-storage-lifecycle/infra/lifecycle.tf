resource "azurerm_storage_management_policy" "lab" {
  storage_account_id = azurerm_storage_account.lab.id

  rule {
    name    = "audit-retention"
    enabled = true

    filters {
      blob_types   = ["blockBlob"]
      prefix_match = ["audit-exports/orders/"]
    }

    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 30
        tier_to_archive_after_days_since_modification_greater_than = 90
      }
    }
  }
}

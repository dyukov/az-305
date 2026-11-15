# Storage params

```hcl
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
```

| Field        | Value           | Meaning                                                                                                                                |
| ------------ | --------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| kind         | StorageV2       | General-purpose v2 account. It's the current default and supports blobs, files, queues, tables, access tiers and lifecycle management. |
| location     | northeurope     | Ireland region. Data stays in that region.                                                                                             |
| name         | staz305la1589sa | Globally unique, 3–24 lowercase letters and digits. It becomes the DNS name `staz305la1589sa.blob.core.windows.net`.                   |
| publicAccess | false           | Anonymous public readount. No container can be made public, even if its own access level says so.                                      |
| sku          | Standard_LRS    | Standard (HDD-backed) performance with locally redundant storage: 3 copies inside one datacenter. It's the cheapest option, er.        |

Why it matters for this lab: lifecycle management policies need a GPv2 account (or a premium block blob account), and this one is GPv2. Moving
data between tiers (Hot → Cool → Cold → Archive) is what

Where the AWS analogy breaks:

- **Account vs. bucket:** An S3 bucket is roughly a containe storage account sits one level higher and holds settings that S3 sets per bucket or per account: redundancy, public-access block, networking and encryption.
- **Redundancy is a choice:** S3 Standard always copies dataty zones. In Azure you pick it with the SKU. LRS means asingle datacenter, and you need ZRS to match S3's zone resilience.
- **Public access block:** `allowBlobPublicAccess=false` worksset at the account level.

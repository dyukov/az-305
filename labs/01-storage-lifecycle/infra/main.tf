resource "azurerm_resource_group" "lab" {
  name     = "rg-az305-storage-lab"
  location = "northeurope"

  tags = {
    environment = "lab"
    project     = "az305"
  }
}

data "azurerm_key_vault_secret" "keyvault-username" {
  name                = "adminusername"
  key_vault_id        = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/CloudShell/providers/Microsoft.KeyVault/vaults/cs-keystore"
}

data "azurerm_key_vault_secret" "keyvault-password" {
  name                = "adminpassword"
  key_vault_id        = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/CloudShell/providers/Microsoft.KeyVault/vaults/cs-keystore"
}

data "azurerm_ssh_public_key" "sshkey" {
  name                = "desktop"
  resource_group_name = "CloudShell"
}

data "azurerm_key_vault_secret" "sharedkey" {
  name                = "sharedkey"
  key_vault_id        = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/CloudShell/providers/Microsoft.KeyVault/vaults/cs-keystore"
}

data "template_file" "csrconfig" {
  count = var.csr_scale
  template = "${file("${path.module}/csr_config.txt")}"
  vars = {
    INDEX = "${count.index}"
    IP1 = azurerm_public_ip.vpngw-pip[0].ip_address
    IP2 = azurerm_public_ip.vpngw-pip[1].ip_address
    CSRPIP = azurerm_public_ip.csr-pip[count.index].ip_address
    SHAREDKEY = data.azurerm_key_vault_secret.sharedkey.value
  }
}

data "azurerm_subscription" "current" {
}
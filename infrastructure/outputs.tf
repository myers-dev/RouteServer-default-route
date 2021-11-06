output "CSR_public_ips" {
    value = azurerm_public_ip.csr-pip.*.ip_address
}

output "Linux_VMs" {
    value = module.linux_vm.*.vm_ids
}
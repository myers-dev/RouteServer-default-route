resource "null_resource" "routeserver" {
  triggers = {
      rg = var.resource_group_name
  }

  provisioner "local-exec" {
    when = create
    command = "./routeserver.sh create > routeserver-create.log"
    interpreter = ["bash", "-c"]

    on_failure = fail

    environment = {
      LOCATION=var.location
      RG=var.resource_group_name
      CSRIPS=join(" ",module.CSR.*.azurerm_network_interface_private_ip_address)
      SUBSCRIPTION=data.azurerm_subscription.current.id
    }

  }  

  provisioner "local-exec" {
    when = destroy
    command = "./routeserver.sh destroy > routeserver-destroy.log"
    interpreter = ["bash", "-c"]

    on_failure = fail

    environment = {
      RG=self.triggers.rg
    }
  }


  # to overcome an error of non-existent RG
  depends_on = [
    azurerm_resource_group.rg,
    module.vnet[0],
    module.vnet[1],
    module.vnet[2]
  ]
}
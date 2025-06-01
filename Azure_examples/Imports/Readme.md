Terraform import: 
If the statefile is deleted or corrupted, We can restore it by using terraform import command.
Notedown all the resources created by deployment and get we can this terraform import syntax from terraform docs at the end of resource the terraform import will be present.
Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet

Example:
-> terraform import azurerm_subnet.exampleSubnet /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysubnet1
-> terraform import azurerm_resource_group.rg

terraform import azurerm_resource_group.existing_rg /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/group1

terraform import azurerm_virtual_network.existing_vnet /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Network/virtualNetworks/myvnet1


terraform init: It will intiate the terraform and download the providers from the hashicorp website. By this we can communicate with Cloud providers infrastructure.

terraform validate: It will get validate the code written the file and check if any error are there or not.

terraform plan: It will dry run the file it didn't create/destroy any infrastructure.

terraform apply: It will apply the changes mention in the code such as creating/destroying the resources.

terraform apply --auto-approve: It will directly apply changes don't ask for yes(or)no.

terraform import -- It is used to import the state of existing resources to the state file.

**Modules in Terraform::

If you want to perform a template-based deployment you can follow modularized approach.
A Module defines a set of parameters which will be passed as key value pairs to actual deployment.

with this approach you can create multiple environments in a very easy way.

To destroy perticular env resources:
terraform destroy --target=module.module_prod
Example:
module "module_test" {
    source = "./modules"
    prefix = "test"
    vnet_cidr_prefix = "10.60.0.0/16"
    subnet1_cidr_prefix = "10.60.1.0/24"
    rgname = "TestRG"
    subnet = "TestSubnet"   
}
**

**Datasources in terraform::

If you deploy your resources out of terraform and use them in your terraform code the way you use them through "Data SOurces".
Data sources in terraform are used to get information about resources external to terraform, and use them to setup your terraform resources.

*If you perform "terraform destroy" command the resources created by using terraform only gets deleted. The resources that out of terraform creation won't be deleted/destroed.

Example:
data "azurerm_resource_group" "rg1" {
  name     = "NextOpsVideos"
}
**

**Locals / Local values ::

A local value assigns a name to an expression, so you can use the name multiple times within a module instead of repeating the expression.

If you're familiar with traditional programming languages, it can be useful to compare Terraform modules to function definitions:

Input variables are like function arguments.
Output values are like function return values.
Local values are like a function's temporary local variables.

Example:

locals {
  # Ids for multiple sets of EC2 instances, merged together
  instance_ids = concat(aws_instance.blue.*.id, aws_instance.green.*.id)
}

locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service = local.service_name
    Owner   = local.owner
  }
}
**

**Restoring the Statefile::

There some way to do if state file got deleted.
After deleting the state file if we run "terraform apply" it will throw an error asying resource already exist.

1. Using terraform import: 
If the statefile is deleted or corrupted, We can restore it by using terraform import command.
Notedown all the resources created by deployment and get we can this terraform import syntax from terraform docs at the end of resource the terraform import will be present.
Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet

Example:
-> terraform import azurerm_subnet.exampleSubnet /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysubnet1
-> terraform import azurerm_resource_group.rg

2. Backend Block:
Stores the state as a Blob with the given Key within the Blob Container within the Blob storage account.
We need to create the storage account and blob storage and get the access key to provide in the app.
While execting the terraform plan/apply it will lock the state file and unlock after operation is done. So that it will make sure the user can't use simutanously.
Example: Using the Access key. After adding this block run terraform init command.

terraform {
  backend "azurerm" {
    access_key           = "abcdefghijklmnopqrstuvwxyz0123456789..."  # Can also be set via `ARM_ACCESS_KEY` environment variable.
    storage_account_name = "abcd1234"                                 # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstate"                                  # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "prod.terraform.tfstate"                   # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
}
**

Data Sources vs Import::

In data sources we will add the existing infra by using data block and create the resources on top of it. But, In import we will import the existing resources state in statefile and create the resources on top of it.



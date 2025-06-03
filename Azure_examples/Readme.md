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
  instance_ids = concat(aws_instance.blue.*.id, aws_instance.green.*.id)
}

locals {
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
    access_key           = "abcdefghijklmnopqrstuvwxyz0123456789..."  
    storage_account_name = "abcd1234"                                 
    container_name       = "tfstate"                                  
    key                  = "prod.terraform.tfstate"                   
  }
}
**

Data Sources vs Import::

In data sources we will add the existing infra by using data block and create the resources on top of it. But, In import we will import the existing resources state in statefile and create the resources on top of it.


**Functions::
The Terraform language includes a number of built-in functions that you can call from within expressions to transform and combine values. The general syntax for function calls is a function name followed by comma-separated arguments in parentheses.

Docs: https://developer.hashicorp.com/terraform/language/functions

Example:
max(5, 12, 9)
12
**

**Provisioners::
It provides the ability to run additional steps (or) tasks when a resource is created (or) destroy.
This not a replacment of configuration management tools.
There are three types of it.
1. File 
This is used to copy the files from our local mechine to the vm created.

Example:
provisioner "file" {
source = "./script.sh"
destination = "/tmp/script.sh"
}

2. Local Exec
This is used to execute the command in local ssystem.
Example:
provisioner "local-exec" {
    command = "echo 'test' > /tmp/test.txt"
}

3. Remote Exec
This to execute command in the remote system created.

Example:
provisioner "local-exec" {
  inline = ["ls -a /tmp"]

}
**

**Workspaces::
To seperate different environments we can use concept of workspaces in terraform.
After creating a workspace teraaform will create a folder naming that workspace name. After executing the apply command the state file will create in that perticular workspace folder.
commands:
terraform workspace list --> It is to list the workspaces available.
terraform workspace new dev --> It is to create the workspace.
terraform workspace select dev --> To switch the workspaces
terraform workspace show --> To check current workspace we are in
terraform init
terraform apply -var-file dev.tfvars --> It create the resources in dev workspace by using the var ilfe provide in the command.

**

**Meta-Arguments::

By default, a resource block configures one real infrastructure object. However, sometimes you want to manage several similar objects (like a fixed pool of compute instances) without writing a separate block for each one. Terraform has two ways to do this: 

count and for_each.

1. Count:
The count meta-argument accepts a whole number, and creates that many instances of the resource or module. Each instance has a distinct infrastructure object associated with it, and each is separately created, updated, or destroyed when the configuration is applied.

example:
resource "aws_instance" "server" {
  count = 4 # create four similar EC2 instances
  name          = "PrasanthVM-${count.index}"
  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"

  tags = {
    Name = "Server ${count.index}"
  }
}

2. Foreach:

The for_each meta-argument accepts a map or a set of strings, and creates an instance for each item in that map or set. Each instance has a distinct infrastructure object associated with it, and each is separately created, updated, or destroyed when the configuration is applied.

Example:
resource "azurerm_resource_group" "rg" {
  for_each = tomap({
    a_group       = "eastus"
    another_group = "westus2"
  })
  name     = each.key
  location = each.value
}
**
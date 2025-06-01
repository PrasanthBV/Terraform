# Terraform
terraform init: It will intiate the terraform and download the providers from the hashicorp website. By this we can communicate with Cloud providers infrastructure.

terraform validate: It will get validate the code written the file and check if any error are there or not.

terraform plan: It will dry run the file it didn't create/destroy any infrastructure.

terraform apply: It will apply the changes mention in the code such as creating/destroying the resources.

terraform apply --auto-approve: It will directly apply changes don't ask for yes(or)no.

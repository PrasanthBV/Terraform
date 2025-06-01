variable "rgname" {
  type = string
  description = "Use for the resource group name"
}

variable "rglocation" {
  type = string
  description = "Use for the resource group location"
  default = "East US"
}

variable "prefix" {
    type = string
    description = "use to provide prefix to all the resources"
}

variable "vnet_cidr_prefix" {
    type = string
    description = "Use to prvoide prefix for vnet"
  
}

variable "subnet1_cidr_prefix" {
  type = string
  description = "Use to prvode prefix for subnet"
}
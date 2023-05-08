#variable "environment" {}
variable "company_short_name" {
  type = string
}
variable "environment_short_name" {
  type = string
}

#variable "location_short_name" {}
#variable "subscription_id" {}
#variable "client_id" {}
#variable "client_secret" {}
#variable "tenant_id" {}

variable "location" {
type = string
description = "Location of the resource group."
}

variable "rg_name" {
type        = string
description = "Name of the Resource group in which to deploy service objects"
}

variable "workspace_name" {
type        = string
description = "caf Name of the Azure Virtual Desktop workspace"
}

variable "vm_name" {
type        = string
description = "caf Name of the azure virtual machine"
}


variable "rfc3339" {
type        = string
description = "Registration token expiration"
}


###################################network###################

variable "vnet_name" {
  type        = string
  description = "Name of domain controller vnet"
}

variable "subnet_name" {
  type =string
  description = "subnet name"
}


########################################sessionhost###################

variable "rdsh_count" {
  type = number
  description = "Number of AVD machines to deploy"
}

variable "vm_size" {
  type = string
  description = "Size of the machine to deploy"
  
}

variable "ou_path" {
  default = ""
}

variable "local_admin_username" {
  type        = string
  description = "local admin username"
}

variable "local_admin_password" {
  type        = string
  description = "local admin password"
  sensitive   = true
}

variable "domain_name" {
  type        = string
  description = "Name of the domain to join"
}

variable "domain_user_upn" {
  type        = string
  description = "Username for domain join (do not include domain name as this is appended)"
}

variable "domain_password" {
  type        = string
  description = "Password of the user to authenticate with the domain"
  sensitive   = true
}


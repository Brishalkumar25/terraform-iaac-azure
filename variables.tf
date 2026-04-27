variable "tenantId" {
  description = "Azure Tenant ID"
  type        = string
}
variable "subscriptionId" {
  description = "Azure Subscription ID"
  type        = string
}
variable "resourceGroupName" {
  description = "Azure Rscouce Group Name"
  type        = string
}


variable "location" {
  description = "Azure location Name"
  type        = string
}
variable "virtualnetwork" {
  description = "Azure virtualnetwork Name"
  type        = string
}

variable "subnetweb_name" {
  description = "Azure subnet web Name"
  type        = string
}

variable "subnet_db_name" {
  description = "Azure subnet db Name"
  type        = string
}

variable "subnet_appGW_name" {
  description = "Azure subnet app gw Name"
  type        = string
}

variable "key_vault_name" {
  description = "KV  Name"
  type        = string
}

variable "managed_identity_name" {
  type    = string
}

variable "subnetweb_address" {
  description = "web subnet"
  type        = list(string)
}

variable "subnet_appGW_address" {
  description = "app gateway subnet"
  type        = list(string)
}

variable "subnet_db_address" {
  description = "db subnet"
  type        = list(string)
}


variable "addresspace_vnet001" {
  description = "Azure vnet 001 cidr"
  type        = list(string)
}

variable "appgw_probe" {
  type = object({
    name                = string
    protocol            = string
    path                = string
    interval            = number
    timeout             = number
    unhealthy_threshold = number
    host                = string
  })
}

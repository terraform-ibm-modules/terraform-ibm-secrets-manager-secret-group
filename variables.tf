##############################################################################
# Input Variables
##############################################################################

variable "region" {
  type        = string
  description = "Region which the Secret Manager is deployed."
}
variable "secrets_manager_guid" {
  type        = string
  description = "Instance ID of Secrets Manager instance in which the Secret will be added."
}
variable "secret_group_name" {
  type        = string
  description = "Name of the Secret Group to be created."
}
variable "secret_group_description" {
  type        = string
  description = "Description of the Secret Group to be created."
}

##############################################################################

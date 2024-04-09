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
variable "endpoint_type" {
  type        = string
  description = "The service endpoint type to communicate with the provided secrets manager instance. Possible values are `public` or `private`"
  default     = "public"
  validation {
    condition     = contains(["public", "private"], var.endpoint_type)
    error_message = "The specified endpoint_type is not a valid selection!"
  }
}

##############################################################################

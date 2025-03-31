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
variable "create_access_group" {
  type        = bool
  description = "Whether to create an access group for the secrets group."
  default     = false
}
variable "access_group_name" {
  type        = string
  description = "Name of the access group to create. If null is passed, the name will be set as '{secret_group_name}-access-group'"
  default     = null
}
variable "access_group_roles" {
  type        = list(string)
  description = "Roles to be given to the created access group."
  default     = null
  validation {
    error_message = "Invalid role set for the access group, all roles must be one of: Reader, Writer, Manager, SecretsReader, Viewer, Operator, Editor, Administrator, Service Configuration Reader, Key Manager"
    condition     = (var.access_group_roles == null ? true : length(setintersection(var.access_group_roles, ["Reader", "Writer", "Manager", "SecretsReader", "Viewer", "Operator", "Editor", "Administrator", "Service Configuration Reader", "Key Manager"])) != 0)
  }
  validation {
    error_message = "When creating an access group, a list of roles must be passed"
    condition     = (var.access_group_roles == null ? !var.create_access_group : (var.create_access_group && length(var.access_group_roles) != 0))
  }
}
variable "access_group_tags" {
  type        = list(string)
  description = "Tags that should be applied to the access group. Only applies if create_access_group is true."
  default     = []
}

##############################################################################

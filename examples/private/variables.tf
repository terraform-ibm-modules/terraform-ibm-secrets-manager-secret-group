variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Token"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "Region to deploy resources in"
  default     = "us-south"
}

variable "prefix" {
  type        = string
  description = "Prefix for name of all resource created by this example"
  default     = "test-sm-sg"
}

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example, if unset a new resource group will be created"
  default     = null
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "existing_sm_instance_crn" {
  type        = string
  description = "An existing Secrets Manager instance CRN. If not provided an new instance will be provisioned."
  default     = null
}

variable "existing_sm_instance_region" {
  type        = string
  description = "The region of the existing Secrets Manager instance. Only required if value is passed into var.existing_sm_instance_guid"
  default     = null
}

variable "skip_iam_authorization_policy" {
  type        = bool
  description = "Whether to skip the creation of the IAM authorization policies required to enable the IAM credentials engine. If set to false, policies will be created that grants the Secrets Manager instance 'Operator' access to the IAM identity service, and 'Groups Service Member Manage' access to the IAM groups service."
  default     = false
}

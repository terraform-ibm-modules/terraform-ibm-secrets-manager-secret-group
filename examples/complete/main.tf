locals {
  sm_guid   = var.existing_sm_instance_guid == null ? ibm_resource_instance.secrets_manager[0].guid : var.existing_sm_instance_guid
  sm_region = var.existing_sm_instance_region == null ? var.region : var.existing_sm_instance_region
}

##################################################################
## Create RG
##################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.0"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##################################################################
## Create prerequisite.  Secrets Manager and Secret Group
##################################################################

resource "ibm_resource_instance" "secrets_manager" {
  count             = var.existing_sm_instance_guid == null ? 1 : 0
  name              = "${var.prefix}-sm-instance"
  service           = "secrets-manager"
  plan              = var.sm_service_plan
  location          = var.region
  resource_group_id = module.resource_group.resource_group_id
  tags              = var.resource_tags
  timeouts {
    create = "20m" # Extending provisioning time to 20 minutes
  }
}

##################################################################
## Example creating secret group
##################################################################

module "secrets_manager_group_acct" {
  source               = "../.."
  region               = local.sm_region
  secrets_manager_guid = local.sm_guid
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  secret_group_name        = "${var.prefix}-example-group"    #checkov:skip=CKV_SECRET_6: does not require high entropy string as is static value
  secret_group_description = "secret group used for examples" #tfsec:ignore:general-secrets-no-plaintext-exposure
}

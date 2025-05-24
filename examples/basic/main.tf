locals {
  sm_guid   = var.existing_sm_instance_guid == null ? module.secrets_manager[0].secrets_manager_guid : var.existing_sm_instance_guid
  sm_region = var.existing_sm_instance_region == null ? var.region : var.existing_sm_instance_region
}

##################################################################
## Create RG
##################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.2.0"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##################################################################
## Create prerequisite.  Secrets Manager and Secret Group
##################################################################

module "secrets_manager" {
  count                = var.existing_sm_instance_guid != null ? 0 : 1
  source               = "terraform-ibm-modules/secrets-manager/ibm"
  version              = "2.3.0"
  secrets_manager_name = "${var.prefix}-sm-instance"
  sm_service_plan      = var.sm_service_plan
  region               = local.sm_region
  resource_group_id    = module.resource_group.resource_group_id
  sm_tags              = var.resource_tags
}

##################################################################
## Example creating secret group
##################################################################

module "secrets_manager_group_acct1" {
  source               = "../.."
  region               = local.sm_region
  secrets_manager_guid = local.sm_guid
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  secret_group_name        = "${var.prefix}-example-group-1"                               #checkov:skip=CKV_SECRET_6: does not require high entropy string as is static value
  secret_group_description = "secret group used for examples, has a matching access group" #tfsec:ignore:general-secrets-no-plaintext-exposure
  create_access_group      = true
  access_group_roles       = ["Operator"]
}

module "secrets_manager_group_acct2" {
  source               = "../.."
  region               = local.sm_region
  secrets_manager_guid = local.sm_guid
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  secret_group_name        = "${var.prefix}-example-group-2"  #checkov:skip=CKV_SECRET_6: does not require high entropy string as is static value
  secret_group_description = "secret group used for examples" #tfsec:ignore:general-secrets-no-plaintext-exposure
  create_access_group      = false
}

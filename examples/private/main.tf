##################################################################
## Create RG
##################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.4.0"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##################################################################
## Create prerequisite.  Secrets Manager and Secret Group
##################################################################

locals {
  validate_sm_region_cnd = var.existing_sm_instance_crn != null && var.existing_sm_instance_region == null
  validate_sm_region_msg = "existing_sm_instance_region must also be set when value given for existing_sm_instance_guid."
  # tflint-ignore: terraform_unused_declarations
  validate_sm_region_chk = regex(
    "^${local.validate_sm_region_msg}$",
    (!local.validate_sm_region_cnd
      ? local.validate_sm_region_msg
  : ""))

  sm_region = var.existing_sm_instance_region == null ? var.region : var.existing_sm_instance_region
}

module "secrets_manager" {
  source                        = "terraform-ibm-modules/secrets-manager/ibm"
  version                       = "2.10.3"
  existing_sm_instance_crn      = var.existing_sm_instance_crn
  resource_group_id             = module.resource_group.resource_group_id
  region                        = local.sm_region
  secrets_manager_name          = "${var.prefix}-sm"
  sm_service_plan               = "trial"
  allowed_network               = "private-only"
  endpoint_type                 = "private"
  sm_tags                       = var.resource_tags
  skip_iam_authorization_policy = var.skip_iam_authorization_policy
}

##################################################################
## Example creating secret group
##################################################################

module "secrets_manager_group_acct" {
  source               = "../.."
  region               = local.sm_region
  secrets_manager_guid = module.secrets_manager.secrets_manager_guid
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  secret_group_name        = "${var.prefix}-example-group"    #checkov:skip=CKV_SECRET_6: does not require high entropy string as is static value
  secret_group_description = "secret group used for examples" #tfsec:ignore:general-secrets-no-plaintext-exposure
  endpoint_type            = "private"
  create_access_group      = true
  access_group_roles       = ["Operator"]
}

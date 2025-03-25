##############################################################################
# Secrets Manager Secret Group
#
# Creates Secret Group within existing Secret Manager instance
##############################################################################

locals {
  # Validation (approach based on https://github.com/hashicorp/terraform/issues/25609#issuecomment-1057614400)
  # tflint-ignore: terraform_unused_declarations
  validate_create_access_group = (var.create_access_group && var.access_group_roles == null) ? tobool("When creating an access group, a list of roles must be set") : true

  access_group_name = coalesce(var.access_group_name, "${var.secret_group_name}-access-group")
}

# Create secret group
resource "ibm_sm_secret_group" "secret_group" {
  name          = var.secret_group_name
  description   = var.secret_group_description
  region        = var.region
  instance_id   = var.secrets_manager_guid
  endpoint_type = var.endpoint_type
}

# Optionally create a corresponding access group
module "iam_access_groups" {
  count             = var.create_access_group ? 1 : 0
  source            = "terraform-ibm-modules/iam-access-group/ibm"
  version           = "1.4.6"
  access_group_name = local.access_group_name
  dynamic_rules     = {}
  add_members       = false
  policies = {
    sm_policy = {
      roles = var.access_group_roles
      tags  = var.access_group_tags
      resources = [{
        service       = "secrets-manager"
        instance_id   = var.secrets_manager_guid
        resource_type = "secret-group"
        resource      = ibm_sm_secret_group.secret_group.secret_group_id
      }]
    }
  }
}

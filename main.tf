##############################################################################
# Secrets Manager Secret Group
#
# Creates Secret Group within existing Secret Manager instance
##############################################################################

# Create secret group
resource "ibm_sm_secret_group" "secret_group" {
  name          = var.secret_group_name
  description   = var.secret_group_description
  region        = var.region
  instance_id   = var.secrets_manager_guid
  endpoint_type = var.endpoint_type
}

locals {
  access_group_name = coalesce(var.access_group_name, "${var.secret_group_name}-access-group")
}

# Optionally create a corresponding access group
module "iam_access_groups" {
  count             = var.create_access_group ? 1 : 0
  source            = "terraform-ibm-modules/iam-access-group/ibm"
  version           = "1.5.4"
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

locals {
  access_group_id = var.create_access_group ? module.iam_access_groups[0].id : null
}

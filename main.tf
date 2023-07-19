##############################################################################
# Secrets Manager Secret Group
#
# Creates Secret Group within existing Secret Manager instance
##############################################################################

# Create secret group
resource "ibm_sm_secret_group" "secret_group" {
  name        = var.secret_group_name
  description = var.secret_group_description
  region      = var.region
  instance_id = var.secrets_manager_guid
}

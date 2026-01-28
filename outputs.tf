##############################################################################
# Outputs
##############################################################################

output "secret_group_id" {
  description = "ID of the created Secret Group"
  value       = ibm_sm_secret_group.secret_group.secret_group_id
}

output "secret_group_name" {
  description = "Name of the created Secret Group"
  value       = ibm_sm_secret_group.secret_group.name
  # as the name is not computed by the provider, using explicit depends_on to only return the name AFTER the group has been created.
  depends_on = [ibm_sm_secret_group.secret_group]
}

output "access_group_id" {
  description = "ID of the created Access Group"
  value       = local.access_group_id
}

##############################################################################

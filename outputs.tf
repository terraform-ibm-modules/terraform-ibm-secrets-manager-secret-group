##############################################################################
# Outputs
##############################################################################

output "secret_group_id" {
  description = "ID of the created Secret Group"
  value       = ibm_sm_secret_group.secret_group.secret_group_id
}

output "access_group_id" {
  description = "ID of the created Access Group"
  value       = module.iam_access_groups[0].id
}

##############################################################################

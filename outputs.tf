##############################################################################
# Outputs
##############################################################################

output "secret_group_id" {
  description = "ID of the created Secret Group"
  value       = ibm_sm_secret_group.secret_group.secret_group_id
}

##############################################################################
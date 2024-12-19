##############################################################################
# Outputs
##############################################################################

output "secret_group_id" {
  description = "ID of the created Secret Group"
  value       = module.secrets_manager_group_acct.secret_group_id
}

##############################################################################

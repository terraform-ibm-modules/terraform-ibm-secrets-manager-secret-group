##############################################################################
# Outputs
##############################################################################

output "secret_group_id1" {
  description = "ID of the first created Secret Group with a matching access group"
  value       = module.secrets_manager_group_acct1.secret_group_id
}

output "access_group_id" {
  description = "ID of the created Access Group"
  value       = module.secrets_manager_group_acct1.access_group_id
}

output "secret_group_id2" {
  description = "ID of the second created Secret Group"
  value       = module.secrets_manager_group_acct2.secret_group_id
}

##############################################################################

# ## Vault Identity MFA TOTP

# resource "vault_identity_mfa_totp" "sam-totp" {
#   issuer  = "HCP-Vault"
#   digits  = 6
#   period  = 20
#   qr_size = 200
# }

# resource "vault_identity_mfa_login_enforcement" "sam-totp" {
#   name = "sam"
#   mfa_method_ids = [
#     vault_identity_mfa_totp.sam-totp.method_id,
#   ]
#   identity_entity_ids = [vault_generic_endpoint.sam_entity.write_data["id"]]
# }

# resource "vault_generic_endpoint" "sam-totp" {
#   depends_on           = [vault_identity_mfa_login_enforcement.sam-totp]
#   disable_read         = true
#   disable_delete       = true
#   path                 = "identity/mfa/method/totp/admin-generate"
#   ignore_absent_fields = true
#   write_fields         = ["url"]

#   data_json = jsonencode({
#     "method_id" : "${vault_identity_mfa_totp.sam-totp.method_id}",
#     "entity_id" : "${vault_generic_endpoint.sam_entity.write_data["id"]}"
#     }
#   )
# }

# output "sam-totp-url" {
#   value = vault_generic_endpoint.sam-totp.write_data["url"]
# }

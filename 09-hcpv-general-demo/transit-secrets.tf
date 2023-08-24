resource "vault_mount" "transit" {
  path        = "transit"
  type        = "transit"
  description = "This is a  transit secret engine mount"

  options = {
    convergent_encryption = false
  }
}

resource "vault_transit_secret_backend_key" "key" {
  backend = vault_mount.transit.path
  name    = "my_key"
    deletion_allowed = true
}

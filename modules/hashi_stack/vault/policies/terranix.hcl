path "kv/*" {
  capabilities = ["create", "read"]
}

// Ability to read mounted paths. needed when interacting with Paths
path "sys/mounts" {
  capabilities = ["read"]
}
// Manage PKI secrets engine
path "sys/mounts/pki" {
  capabilities = ["create", "read", "update", "delete"]
}
path "sys/mounts/pki_int" {
  capabilities = ["create", "read", "update", "delete"]
}

// Tune secrets engine TTL
path "sys/mounts/pki/tune" {
  capabilities = [ "update" ]
}
path "sys/mounts/pki_int/tune" {
  capabilities = [ "update" ]
}

// Manage root cert from PKI secret backend "pki/root"
path "pki/root" {
  capabilities = [ "read","delete", "sudo" ]
}
// Manage root cert for PKI secret backend "pki"
path "pki/root/generate/internal" {
  capabilities = [ "read","create", "update","delete" ]
}
path "pki/issuers/generate/root/internal" {
  capabilities = [ "read","create", "update","delete" ]
}

// Manage intermediate cert for PKI secret backend "pki_int"
path "pki_int/intermediate/generate/internal" {
  capabilities = [ "read","create", "update","delete" ]
}
path "pki_int/issuers/generate/intermediate/internal" {
  capabilities = [ "read","create", "update","delete" ]
}
path "pki/issuer/*" {
  capabilities = [ "read","create", "update","delete" ]
}

// Configure CRL location and issuing certificates
path "pki/config/urls" {
  capabilities = [ "read", "create", "update"  ]
}
path "pki_int/config/urls" {
  capabilities = [ "read", "create", "update"  ]
}
// Signing CSRs
path "pki/root/sign-intermediate" {
  capabilities = [ "sudo", "read", "create", "update","delete" ]
}
// Set Signed CSRs
path "pki_int/intermediate/set-signed" {
  capabilities = [ "read", "create", "update","delete" ]
}
// Revoke certificates
path "pki/revoke" {
  capabilities = [ "sudo", "read", "create", "update","delete" ]
}
path "pki_int/revoke" {
  capabilities = [ "sudo", "read", "create", "update","delete" ]
}
// Create role for backend "pki_int"
path "pki_int/roles/dc1.consul" {
  capabilities = [ "read","create", "update", "delete"  ]
}
path "pki_int/roles/global.nomad" {
  capabilities = [ "read","create", "update", "delete"  ]
}
// manage issuing certificates
path "pki_int/issue/dc1.consul" {
  capabilities = [ "read","create", "update", "delete"  ]
}
path "pki_int/issue/global.nomad" {
  capabilities = [ "read","create", "update", "delete"  ]
}

// manage Tokens
path "auth/token/lookup-accessor" {
  capabilities = ["update"]
}
path "auth/token/revoke-accessor" {
  capabilities = ["update"]
}
// Create Tokens
path "auth/token/create" {
  capabilities = ["create", "update"]
}
path "auth/token/create/certs_renewer" {
  capabilities = ["update"]
}

// Manage Sops
path "sys/mounts/sops" {
  capabilities = ["create", "read", "update", "delete"]
}
path "sys/mounts/sops/tune" {
  capabilities = [ "update" ]
}
path "sops/keys/main/config" {
  capabilities = [ "read", "create", "update"  ]
}
path "sops/keys/main" {
  capabilities = ["create", "read", "update", "delete"]
}

// Nomad vault integration
path "sys/policies/acl/nomad_server_policy" {
  capabilities = ["create", "read", "update", "delete"]
}
path "auth/token/roles/nomad_token_role" {
  capabilities = ["create", "read", "update", "delete"]
}

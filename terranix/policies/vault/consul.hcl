
//--- Read PKI secrets engine
path "sys/mounts/pki" {
  capabilities = ["read"]
}
path "sys/mounts/pki_int" {
  capabilities = ["read"]
}

// Manage intermediate pki engine
path "sys/mounts/pki_int/tune" {
  capabilities = [ "update" ]
}



//--- Read PKI engine to auto rotate intermediate CAs as needed
path "pki" {
  capabilities = [ "read" ]
}

// Signing CSRs
path "pki/root/sign-intermediate" {
  capabilities = [ "update" ]
}

path "pki_int/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}



//--- Allow renewing token if renewable
path "auth/token/renew-self" {
  capabilities = [ "update" ]
}

path "auth/token/lookup-self" {
  capabilities = [ "read" ]
}


//--- Needed for trying to change CA provider or changing root pki path
path "pki/root/sign-self-issued" {
  capabilities = [ "sudo", "update" ]
}


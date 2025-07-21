{x, ...}: {
  provider.vault = {
    address = x.vault.VAULT_ADDR;
    auth_login = {
      path = "auth/approle/login";
      parameters = {role_id = x.vault.terraform_approle_id;};
    };
  };
}

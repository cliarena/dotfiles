# INFO: Nomad + Vault integration:
## - so Nomad can retreive tokens with least priviledges from Vault for its jobs
{x, ...}: let
  inherit (x.time) minute hour day year;

  nomad_server_policy = builtins.toJSON {
    path = {
      # Allow creating tokens under "nomad_token_role" token role. The token role name
      # should be updated if "nomad_token_role" is not used.
      "auth/token/create/nomad_token_role".capabilities = ["update"];
      # Allow looking up "nomad-cluster" token role. The token role name should be
      # updated if "nomad-cluster" is not used.
      "auth/token/roles/nomad_token_role".capabilities = ["read"];
      # Allow looking up the token passed to Nomad to validate # the token has the
      # proper capabilities. This is provided by the "default" policy.
      "auth/token/lookup-self".capabilities = ["read"];
      # Allow looking up incoming tokens to validate they have permissions to access
      # the tokens they are requesting. This is only required if
      # `allow_unauthenticated` is set to false.
      "auth/token/lookup".capabilities = ["update"];
      # Allow revoking tokens that should no longer exist. This allows revoking
      # tokens for dead tasks.
      "auth/token/revoke-accessor".capabilities = ["update"];
      # Allow checking the capabilities of our own token. This is used to validate the
      # token upon startup. Note this requires update permissions because the Vault API
      # is a POST
      "sys/capabilities-self".capabilities = ["update"];
      # Allow our own token to be renewed.
      "auth/token/renew-self".capabilities = ["update"];
    };
  };
in {
  # Policy used by Nomad for creating and managing its jobs tokens
  resource.vault_policy.nomad_server_policy = {
    name = "nomad_server_policy";
    policy = nomad_server_policy;
  };

  # Token Role to manage what Vault policies are accessible by jobs submitted to Nomad
  resource.vault_token_auth_backend_role.nomad_token_role = {
    role_name = "nomad_token_role";
    disallowed_policies = ["nomad_server_policy"];
    orphan = true;
    token_period = 3 * day;
    renewable = true;
    token_explicit_max_ttl = 0;
  };

  # resource.vault_token.certs_renewer_token = {
  #   # role_name = "certs_renewer";
  #   # policies = [ "policy1" "policy2" ];
  #   renewable = true;
  #   ttl = 1 * day;
  #   metadata = { purpose = "renew_certs"; };
  # };
}

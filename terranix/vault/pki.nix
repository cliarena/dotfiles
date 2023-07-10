{ config, x, ... }:
let
  inherit (config.resource.vault_mount) pki pki_int;
  inherit (x) time vault consul;
  inherit (vault) VAULT_ADDR;
  inherit (consul) consul_domain;
  inherit (time) minute hour day year;
in {

  # Generate root CA
  resource.vault_mount.pki = {
    path = "pki";
    type = "pki";
    default_lease_ttl_seconds = 3600;
    max_lease_ttl_seconds = 10 * year;
    description = "Root Certificates issuer";
  };

  # Generate intermediate CA
  resource.vault_mount.pki_int = {
    path = "pki_int";
    type = "pki";
    default_lease_ttl_seconds = 3600;
    max_lease_ttl_seconds = 5 * year;
    description = "Intermediate Certificates issuer";
  };

  # Generate new self-signed certificate
  resource.vault_pki_secret_backend_root_cert.consul = {
    depends_on = [ "vault_mount.pki" ];
    backend = pki.path;
    type = "internal";
    common_name = "${consul_domain} Root CA";
    # exclude_cn_from_sans = true;
    ttl = 10 * year;
    format = "pem";
    private_key_format = "der";
    key_type = "rsa";
    key_bits = 4096;
  };

  # Update the CRL location and issuing certificates
  resource.vault_pki_secret_backend_config_urls.consul = {
    depends_on = [ "vault_mount.pki" ];
    backend = pki.path;
    issuing_certificates = [ "${VAULT_ADDR}/v1/pki/ca" ];
    crl_distribution_points = [ "${VAULT_ADDR}/v1/pki/crl" ];
  };
  resource.vault_pki_secret_backend_config_urls.consul_int = {
    depends_on = [ "vault_mount.pki_int" ];
    backend = pki_int.path;
    issuing_certificates = [ "${VAULT_ADDR}/v1/pki_int/ca" ];
    crl_distribution_points = [ "${VAULT_ADDR}/v1/pki_int/crl" ];
  };

  # Request intermediate certificate signing request (CSR)
  resource.vault_pki_secret_backend_intermediate_cert_request.consul_int_csr = {
    depends_on = [ "vault_pki_secret_backend_root_cert.consul" ];
    backend = pki_int.path;
    type = config.resource.vault_pki_secret_backend_root_cert.consul.type;
    common_name = "${consul_domain} Intermediate Certificate";
    # exclude_cn_from_sans = true;
    format = "pem";
    private_key_format = "der";
    key_type = "rsa";
    key_bits = 4096;
  };

  # Sign intermediate CSR
  resource.vault_pki_secret_backend_root_sign_intermediate.consul_int_signed_csr =
    {
      depends_on =
        [ "vault_pki_secret_backend_intermediate_cert_request.consul_int_csr" ];
      backend = pki.path;
      csr =
        "\${vault_pki_secret_backend_intermediate_cert_request.consul_int_csr.csr}";
      common_name = "${consul_domain} Intermediate Certificate";
      exclude_cn_from_sans = true;
      # revoke = true;
      format = "pem_bundle";
      ttl = 5 * year;
    };

  # import certificate into vault
  resource.vault_pki_secret_backend_intermediate_set_signed.consul_int_csr = {
    depends_on = [
      "vault_pki_secret_backend_root_sign_intermediate.consul_int_signed_csr"
    ];
    backend = pki_int.path;
    certificate =
      "\${vault_pki_secret_backend_root_sign_intermediate.consul_int_signed_csr.certificate}";
  };

  # Create role pki_role for backend "pki"
  resource.vault_pki_secret_backend_role.consul-dc1 = {
    depends_on = [ "vault_mount.pki_int" ];
    backend = pki_int.path;
    key_type = "rsa";
    key_bits = 4096;
    name = consul_domain;
    allowed_domains = [ consul_domain ];
    allow_subdomains = true;
    max_ttl = 30 * day;
  };

  # Generate server certificate
  # TEST: Maybe not needed when there is consul-template
  # resource.vault_pki_secret_backend_cert.consul-server = {
  #   depends_on = [ "vault_pki_secret_backend_role.consul-dc1" ];
  #   backend = pki_int.path;
  #   name = config.resource.vault_pki_secret_backend_role.consul-dc1.name;
  #   common_name = "server.dc1.consul";
  #   ttl = 7 * day;
  #   auto_renew = true;
  #   min_seconds_remaining = 3 * day;
  #   revoke = true;
  # };
}

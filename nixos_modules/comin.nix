{ config, inputs, lib, ... }:
let
  module = "_comin";
  deskription = "GitOps For NixOS Machines";
  inherit (lib) mkEnableOption mkIf;
in {
  imports = [ inputs.comin.nixosModules.comin ];

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    services.comin = {
      enable = true;
      remotes = [{
        name = "origin";
        url = "https://gitlab.com/cliarena_dotfiles/nixos";
        # This is an access token to access our private repository
        # auth.access_token_path = cfg.sops.secrets."gitlab/access_token".path;
        # No testing branch on this remote
        branches.testing.name = "";
      }];
    };
  };

}

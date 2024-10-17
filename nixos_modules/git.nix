{ config, lib, inputs, host, pkgs, ... }:
let
  module = "_git";
  description = "version control config";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager sops-nix;
in {

  imports = [ home-manager.nixosModules.home-manager ];
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    home-manager.users.${host.user} = { config, ... }: {
      programs.git = {
        enable = true;
        userName = "CLI Arena";
        userEmail = "git@cliarena.com";
        signing.signByDefault = true;
        # the private key of public key added to git instance to sign commits
        signing.key = config.sops.secrets.GL_SSH_KEY.path;
        extraConfig = {
          init.defaultBranch = "main";
          gpg.format = "ssh";
          url = {
            "git@gitlab.com:cliarena_dotfiles/nixos" = { insteadOf = "nixos"; };
            "git@gitlab.com:persona_code/notes" = { insteadOf = "notes"; };
            "git@gitlab.com:clxarena/" = { insteadOf = "arena:"; };
            "git@gitlab.com" = { insteadOf = "gl"; };
            "git@github.com" = { insteadOf = "gh"; };
          };
        };
      };
    };
  };
}

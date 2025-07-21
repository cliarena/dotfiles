{
  config,
  lib,
  pkgs,
  inputs,
  host,
  ...
}: let
  module = "_home_gitter";
  description = "auto git clone repos on boot";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager;
in {
  imports = [home-manager.nixosModules.home-manager];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    home-manager.users.${host.user} = {config, ...}: let
      gc = "${pkgs.git}/bin/git  clone --config ${git_config}";
      git_config = "core.sshCommand='${pkgs.openssh}/bin/ssh -i ${config.sops.secrets.GL_SSH_KEY.path}'";
    in {
      systemd.user.services.gitter = {
        Unit.Description = "auto git clone repos on boot";
        Install.WantedBy = ["default.target"];

        Service.ExecStart = pkgs.writeShellScript "gitter" ''
          ${gc}  git@gitlab.com:persona_code/notes ~/notes
          ${gc}  git@gitlab.com:cliarena_dotfiles/nixos ~/dotfiles

          ${gc}  git@gitlab.com:mallx/products ~/project_main
        '';
      };
    };
  };
}

{ pkgs, host, ... }: {
  services.kmscon = {
    enable = true;
    autologinUser = host.user;
    # only firacode and hack fonts work
    extraConfig = ''
      font-name=FiraCode Nerd Font Mono
      font-size=10
    '';
    # font-size=8
    #font-name=Hack Nerd Font Mono
    # Dont use fonts option since it installs all nerdfonts
    #fonts = [{
    #  name = "FiraCode Nerd Font Mono";
    #  package = pkgs.nerdfonts;
    #}];
  };
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;
    };
  };
}

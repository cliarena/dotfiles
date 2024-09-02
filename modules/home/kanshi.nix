{ ... }: {
  services.kanshi = {
    enable = true;
    profiles = {
      stream = {
        outputs = [{
          criteria = "WL-1";
          status = "enable";
          mode = "1920x1080@60Hz";
        }];
      };
    };
  };
}

{ ... }: {
  terraform.required_providers = { remote = { source = "tenstad/remote"; }; };
  provider.remote = {
    alias = "PI";
    max_sessions = 2;
    conn = {
      host = "10.10.0.2";
      port = 4729;
      user = "pi";
      # sudo = true;
      private_key_path = "/home/x/.ssh/PI";
    };
  };
}

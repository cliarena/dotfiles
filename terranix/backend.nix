{...}: {
  terraform.backend.consul = {
    scheme = "http";
    path = "terranix";
  };
}

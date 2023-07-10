{ x, ... }: {
  provider.consul = {
    address = x.consul.CONSUL_ADDR;
    datacenter = "dc1";
  };
}

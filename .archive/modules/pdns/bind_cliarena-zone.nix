{ self, host }:
builtins.toFile "bind_cliarena-zone" ''
  $TTL 2d
  $ORIGIN cliarena.com.
  @                 IN    SOA   ns.cliarena.com.   reporter.cliarena.com. (
                                ${
                                  builtins.toString self.sourceInfo.lastModified
                                }
                                12h
                                15m
                                3w
                                2h
                                )
                    IN    NS    ns.cliarena.com.
  ns                IN    A     ${host.ip_addr}

  @                 IN    A     ${host.ip_addr}
  *                 IN    A     ${host.ip_addr}
''

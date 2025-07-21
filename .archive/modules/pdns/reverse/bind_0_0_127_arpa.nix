self:
builtins.toFile "bind_0_0_127_arpa" ''
  $TTL 2d
  0.0.127.in-addr.arpa.   IN    SOA   ns.cliarena.com.   reporter.cliarena.com. (
                                ${
    builtins.toString self.sourceInfo.lastModified
  }
                                12h
                                15m
                                3w
                                2h
                                )
                    IN    NS    ns.cliarena.com.

  131               IN    PTR   vault.cliarena.com
''

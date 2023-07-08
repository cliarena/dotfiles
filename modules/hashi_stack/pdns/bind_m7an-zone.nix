{ self, host }:
builtins.toFile "bind_m7an-zone" ''
  $TTL 2d
  $ORIGIN m7an.com.
  @                 IN    SOA   ns.m7an.com.   mail.m7an.com. (
                                ${
                                  builtins.toString self.sourceInfo.lastModified
                                }
                                12h
                                15m
                                3w
                                2h
                                )
                    IN    NS    ns.m7an.com.
  ns                IN    A     ${host.ip_addr}

  @                 IN    A     ${host.ip_addr}
  *                 IN    A     ${host.ip_addr}
''

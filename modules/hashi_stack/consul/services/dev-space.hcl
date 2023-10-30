service {
  name = "dev-space"
  id   = "dev-space"
  address = "10.10.0.100"
  port = 3389
  connect {
  sidecar_service {}
}

}

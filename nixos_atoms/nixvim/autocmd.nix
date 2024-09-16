{ ... }: {
  autoCmd = [{
    desc = "Auto-refresh buffer if file changed externally";
    command = "if mode() != 'c' | checktime | endif";
    event = [ "FocusGained" "BufEnter" "CursorHold" "CursorHoldI" ];
    pattern = [ "*" ];

  }];
}

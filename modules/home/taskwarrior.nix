{ pkgs, ... }:
let

  timewarrior_theme = builtins.toFile "catppuccin.theme" ''
    define theme:
      description = "catppuccin.theme: A soothing theme for timewarrior"
      colors:
        # General UI color.
        exclusion = "black"
        today     = "green"
        holiday   = "magenta"
        label     = "black"
        ids       = "yellow"
        debug     = "blue"

      # Rotating Color Palette for tags. The leading zeroes allow the order to be
      # preserved.
      palette:
        color01 = "black on red"
        color02 = "black on blue"
        color03 = "black on green"
        color04 = "black on magenta"
        color05 = "black on cyan"
        color06 = "black on yellow"
        color07 = "black on white"
  '';
  taskwarrior_theme = builtins.toFile "catppuccin.theme" ''
    # Theme colors for catppuccin

    # General decoration
    color.label=magenta
    color.label.sort=magenta
    color.alternate=
    color.header=cyan
    color.footnote=yellow
    color.warning=bold red
    color.error=white on red
    color.debug=blue

    # Task state
    color.completed=black
    color.deleted=red
    color.active=green
    color.recurring=blue
    color.scheduled=white on green
    color.until=yellow
    color.blocked=black on white
    color.blocking=black on bright white

    # Project
    color.project.none=red

    # Priority
    color.uda.priority.H=bold white
    color.uda.priority.M=white
    color.uda.priority.L=

    # Tags
    color.tag.next=bold yellow
    color.tag.none=
    color.tagged=

    # Due
    color.due=red
    color.due.today=red
    color.overdue=bold red

    # UDA
    #color.uda.X=

    # Report: burndown
    color.burndown.done=on green
    color.burndown.pending=on magenta
    color.burndown.started=on blue

    # Report: history
    color.history.add=black on blue
    color.history.delete=black on red
    color.history.done=black on green

    # Report: summary
    color.summary.background=
    color.summary.bar=black on green

    # Command: calendar
    color.calendar.due=red
    color.calendar.due.today=underline bold red
    color.calendar.holiday=black on bright yellow
    color.calendar.overdue=bold white on bright red
    color.calendar.scheduled=green
    color.calendar.today=black on cyan
    color.calendar.weekend=black
    color.calendar.weeknumber=bold blue

    # Command: sync
    color.sync.added=green
    color.sync.changed=yellow
    color.sync.rejected=red

    # Command: undo
    color.undo.after=green
    color.undo.before=red
  '';
in {
  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
    colorTheme = taskwarrior_theme;
  };
}

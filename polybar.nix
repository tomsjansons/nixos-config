{ pkgs, ... }:


{
  enable = true;

  package = pkgs.polybar.override {
    alsaSupport = true;
    i3Support = true;
  };

  script = ''
    PATH=$PATH:${pkgs.i3}/bin
    PATH=$PATH:${pkgs.toybox}/bin
    PATH=$PATH:${pkgs.xorg.xrandr}/bin

    # Terminate already running bar instances
    killall -q polybar

    # Wait until the processes have been shut down
    while pgrep -x polybar >/dev/null; do sleep 1; done

    screens=$(xrandr --listactivemonitors | grep -v "Monitors" | cut -d" " -f6)

    if [[ $(xrandr --listactivemonitors | grep -v "Monitors" | cut -d" " -f4 | cut -d"+" -f2- | uniq | wc -l) == 1 ]]; then
      MONITOR=$(polybar --list-monitors | cut -d":" -f1) TRAY_POS=right polybar primary &
    else
      primary=$(xrandr --query | grep primary | cut -d" " -f1)

      for m in $screens; do
        if [[ $primary == $m ]]; then
            MONITOR=$m TRAY_POS=right polybar primary &
        else
            MONITOR=$m TRAY_POS=none polybar secondary &
        fi
      done
    fi
  '';

  config = {
    "global/wm" = {
      margin-bottom = 0;
      margin-top = 0;
    };

    "bar/primary" = {
      monitor = "\${env:MONITOR:eDP1}";
      monitor-exact = false;

      modules-right = "datetime";
      modules-left = "i3";
    };

    "bar/secondary" = {
      monitor = "\${env:MONITOR:eDP1}";
      monitor-exact = false;

      modules-right = "datetime";
      modules-left = "i3";
    };

    "module/datetime" = {
      type = "internal/date";

      interval = "1.0";

      time = "%H:%M:%S";
      date = "%Y-%m-%d%";

      label = "%date% %time%";
    };

    "module/i3" = {
      type = "internal/i3";
      pin-workspaces = true;
      label-focused-foreground = "#ff0000";
    };

  };
}

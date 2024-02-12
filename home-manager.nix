{ config, pkgs, home-manager, ... }:
{
  imports = [
    home-manager.nixosModules.default
  ];

  home-manager.users.root = {
    programs.git = {
      enable = true;
      userName  = "Toms Jansons";
      userEmail = "toms.jansons@hood-software.lv";
    };

    home.stateVersion = "18.09";
  };

  home-manager.users.toms = {
    /* The home.stateVersion option does not have a default and must be set */
    programs.git = {
      enable = true;
      userName  = "Toms Jansons";
      userEmail = "toms.jansons@hood-software.lv";
    };

    programs.bash = {
      enable = true;
    };

    services.fusuma = {
      enable = true;
      extraPackages = with pkgs; [ 
        xdotool 
        coreutils-full 
        xorg.xprop
      ];
      settings = {
        threshold = { swipe = 0.1; };
        interval = { swipe = 0.7; };
        swipe = {
          "3" = {
            left = {
              # GNOME: Switch to left workspace
              command = "xdotool key ctrl+alt+Left";
            };
            right = {
              # GNOME: Switch to right workspace
              command = "xdotool key ctrl+alt+Right";
            };
          };
        };
      };
    };

    home.stateVersion = "18.09";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
  };
}

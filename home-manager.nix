{ config, pkgs, home-manager, lib, ... }:
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

    programs.kitty = {
      enable = true;
    };

    xdg.configFile.nvim = {
      source = /etc/nixos/nvim;
      recursive = true;
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      extraConfig = ''
      	:luafile ~/.config/nvim/lua/init.lua
      '';
      extraPackages = with pkgs; [
        nodejs_21
        corepack_21
        xclip    
        libgcc
        cl
        zig
        rocmPackages.llvm.clang
      ];
    };

    services.fusuma = {
      enable = false;
      extraPackages = with pkgs; [ xdotool ];
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

args@{ config, pkgs, home-manager, lib, ... }:
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
    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = [ "graphical-session-pre.target" ];
      };
    };

    /* The home.stateVersion option does not have a default and must be set */
    programs.git = {
      enable = true;
      userName  = "Toms Jansons";
      userEmail = "toms.jansons@hood-software.lv";
    };

    programs.bash = {
      enable = true;
    };

    programs.rofi = {
      enable = true;
      theme = "arthur";
    };

    programs.autorandr = {
      enable = true;
    };

    services.dunst = import /etc/nixos/dunst.nix (args);
    services.flameshot = {
      enable = true;
      settings = {  
        General = {    
          disabledTrayIcon = false;    
          showStartupLaunchMessage = true;  
        };
      };
    };

    programs.kitty = {
      enable = true;
      keybindings = {
        "ctrl+shift+h" = "previous_tab";
        "ctrl+shift+l" = "next_tab";
        "ctrl+shift+k" = "previous_window";
        "ctrl+shift+j" = "next_window";
      };
    };

    services = {
      polybar = import /etc/nixos/polybar.nix (args);
    };

    xdg.configFile = {
      nvim = {
        source = /etc/nixos/nvim;
        recursive = true;
      };
      i3 = {
        source = /etc/nixos/i3;
        recursive = true;
      };
      vivaldi-css = {
        source = /etc/nixos/vivaldi-css;
        recursive = true;
      };
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

    home.stateVersion = "18.09";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
  };
}

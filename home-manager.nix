args@{ config, pkgs, home-manager, lib, helix, ... }:
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


  home-manager.users.toms = 
  let
    homeSessionVars = config.home-manager.users.toms.home.sessionVariables;
  in { config, pkgs, ... }: {
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

    programs.zellij = {
      enable = true;
    };

    programs.yazi = {
      enable = true;
    };

    programs.wofi = {
      enable = true;
    };

    services.cliphist = {
      enable = true;
    };

    programs.waybar = {
      enable = true;
    };

    services.network-manager-applet.enable = true;

    programs.swaylock = {
      enable = true;
      settings = {
        color = "303030";
        font-size = 24;
        indicator-idle-visible = false;
        indicator-radius = 100;
        line-color = "ffffff";
        show-failed-attempts = true;
      };
    };

    programs.alacritty = {
      enable = true;
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

    # home.file."./.config/nvim/lazy-lock.json".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nvim/lazy-lock.json";

    # home.file."./.config/nvim/" = {
    #   source = ./nvim;
    #   recursive = true;
    # };

    xdg.configFile = {
      # nvim conf is split because we need lazy-lock.json to be readable
      # "nvim/init.lua" = {
      #   source = /etc/nixos/nvim/init.lua;
      #   target = "nvim/init.lua";
      # };
      # "nvim/lua" = {
      #   source = /etc/nixos/nvim/lua;
      #   recursive = true;
      #   target = "nvim/lua";
      # };
      helix = {
        source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/helix;
        recursive = true;
      };
      nvim = {
        source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/nvim;
        recursive = true;
      };
      hypr = {
        source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/hypr;
        recursive = true;
      };
      waybar = {
        source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/waybar;
        recursive = true;
      };
      system_scripts = {
        source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/system_scripts;
        recursive = true;
      };
      yazi = {
        source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/yazi;
        recursive = true;
      };
      zellij = {
        source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/zellij;
        recursive = true;
      };
      alacritty = {
        source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/alacritty;
        recursive = true;
      };
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/background" = {
          picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
        };
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome.gnome-themes-extra;
      };
      iconTheme = {
        package = pkgs.gnome.adwaita-icon-theme;
        name = "adwaita-icon-theme";
      };

      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };

      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };

    systemd.user.sessionVariables = homeSessionVars;

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };

    programs.helix = {
      enable = true;
      package = helix.packages.${pkgs.system}.default;
      extraPackages = with pkgs; [
        nodejs_21
        nodePackages."@astrojs/language-server"
        nodePackages.svelte-language-server
        nodePackages.typescript-language-server
        yaml-language-server
        taplo
        nil
        nodePackages.vscode-json-languageserver
        dockerfile-language-server-nodejs
        tailwindcss-language-server
        nodePackages.bash-language-server
        nodePackages_latest.prettier
        marksman
        typescript
        vscode-langservers-extracted
      ];
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      # extraConfig = ''
      # 	:luafile ~/.config/nvim/init.lua
      # '';
      extraPackages = with pkgs; [
        nodejs_21
        corepack_21
        xclip    
        libgcc
        cl
        zig
        rocmPackages.llvm.clang
        python3
      ];
    };

    home.stateVersion = "18.09";

    home.packages = [
      pkgs.networkmanagerapplet # nm-applet service needs this for icons https://github.com/NixOS/nixpkgs/issues/32730#issuecomment-1618895817
    ];
  };
}

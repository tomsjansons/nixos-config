args@{ 
  config, 
  pkgs, 
  home-manager, 
  lib, 
  helix, 
  ... 
}:
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
      package = args.yazi.packages.${builtins.currentSystem}.default;
      enableFishIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
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

    programs.btop = {
      enable = true;
    };

    programs.fish = {
      enable = true;
      shellAliases = {
        nixconf = "cd /etc/nixos && sudo -E nvim"; 
        nixupd = "sudo nixos-rebuild switch --impure";
        nixsh = "nix-shell --command fish";
        nixshp = "nix-shell --command fish -p";
        nixupgrade = "cd /etc/nixos/ && sudo nix flake update && sudo nixos-rebuild switch --upgrade --impure";
        lsa = "eza -la";
        ls = "eza";
        # cd = "z";
      };

      interactiveShellInit = ''
        set fish_greeting # Disable greeting
        set --universal pure_show_system_time true
        set --universal pure_color_system_time pure_color_mute
        set --universal pure_enable_nixdevshell	true
        set --universal pure_show_prefix_root_prompt true
      '';
      plugins = [
        # Enable a plugin (here grc for colorized command output) from nixpkgs
        { name = "grc"; src = pkgs.fishPlugins.grc.src; }
        { name = "pure"; src = pkgs.fishPlugins.pure.src; }
        # Manually packaging and enable a plugin
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
            owner = "g-plane";
            repo = "pnpm-shell-completion";
            rev = "259e0b4ae5af4634dbb2fb2e39b916a75036d921";
            sha256 = "sha256-3mDmFmRbYzhvoUC+nqW3ge4yLRsiaxAyGRkIC//vpsg=";
          };
        }
      ];
    };

    services.network-manager-applet.enable = true;


    programs.alacritty = {
      enable = true;
    };

    xdg.configFile = {
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
      };
      "hypr-plugins-hyprscroller" = {
        target = "hypr-plugins/libhyprscroller.so";
        source = "${args.hyprscroller.packages.${pkgs.system}.default}/lib/libhyprscroller.so";
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
      swaync = {
        source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/swaync;
        recursive = true;
      };
      wofi = {
        source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/wofi;
        recursive = true;
      };
      niri = {
        source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/niri;
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
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
      iconTheme = {
        package = pkgs.gnome.adwaita-icon-theme;
        name = "adwaita-icon-theme";
      };
      cursorTheme = {
        name = "phinger-cursors-light";
        package = pkgs.phinger-cursors;
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
    
    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };


    home.sessionVariables = {
      XCURSOR_THEME = "phinger-cursors-light";
      XCURSOR_SIZE = 24;
    };

    home.pointerCursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 24;
      gtk.enable = true;
    };

    systemd.user.sessionVariables = homeSessionVars;

    systemd.user.services.battery-check = {
      Unit = {
        Description = "Battery check service";
      };

      Service = {
        Type = "simple";
        ExecStart = toString (
          pkgs.writeShellScript "battery-check-script" ''
            PATH=$PATH:${lib.makeBinPath [ 
              pkgs.which 
              pkgs.coreutils 
              pkgs.gnugrep 
              pkgs.acpi 
              pkgs.libnotify 
            ]} ${pkgs.bash}/bin/bash /home/toms/.config/system_scripts/battery-check.sh
        '');
        RestartSec = 3;
        Restart = "always";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    programs.helix = {
      enable = true;
      package = helix.packages.${pkgs.system}.default;
      extraPackages = with pkgs; [
        nodejs_22
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
      package = args.neovim-nightly-overlay.packages.${pkgs.system}.default;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      extraPackages = with pkgs; [
        vimPlugins.markdown-preview-nvim
        nodejs_22
        corepack_22
        libgcc
        wl-clipboard
        wl-clipboard-x11
        cl
        zig
        rocmPackages.llvm.clang
        python3
        lemminx
      ];
    };

    programs.obs-studio = {
      enable = true;
      plugins = [
        pkgs.obs-studio-plugins.wlrobs
      ];
    };

    home.stateVersion = "18.09";

    home.packages = [
      pkgs.networkmanagerapplet # nm-applet service needs this for icons https://github.com/NixOS/nixpkgs/issues/32730#issuecomment-1618895817
    ];
  };
}

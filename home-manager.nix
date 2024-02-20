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

    services.dunst = {
      enable = true;
      settings = {
        global = {
          font = "FiraCode 12";
          markup = "yes";
          plain_text = "no";
          format = "<b>%s</b>\n%b";
          sort = "no";
          indicate_hidden = "yes";
          alignment = "center";
          bounce_freq = 0;
          show_age_threshold = -1;
          word_wrap = "yes";
          ignore_newline = "no";
          stack_duplicates = "yes";
          hide_duplicate_count = "yes";
          geometry = "300x50-15+49";
          shrink = "no";
          transparency = 5;
          idle_threshold = 10;
          follow = "mouse";
          sticky_history = "yes";
          history_length = 35;
          show_indicators = "yes";
          line_height = 3;
          separator_height = 2;
          padding = 6;
          horizontal_padding = 6;
          separator_color = "frame";
          startup_notification = false;
          dmenu = "${pkgs.dmenu}/bin/dmenu -p dunst:";
          browser = "${pkgs.vivaldi}/bin/vivaldi -new-tab";
          icon_position = "off";
          max_icon_size = 80;
          frame_width = 3;
          frame_color = "#8EC07C";
        };

        shortcuts = {

          # Shortcuts are specified as [modifier+][modifier+]...key
          # Available modifiers are "ctrl", "mod1" (the alt-key), "mod2",
          # "mod3" and "mod4" (windows-key).
          # Xev might be helpful to find names for keys.

          # Close notification.
          close = "ctrl+space";

          # Close all notifications.
          close_all = "ctrl+shift+space";

          # Redisplay last message(s).
          # On the US keyboard layout "grave" is normally above TAB and left
          # of "1".
          history = "ctrl+grave";

          # Context menu.
          context = "ctrl+shift+period";
        };

        urgency_low = {
          # IMPORTANT: colors have to be defined in quotation marks.
          # Otherwise the "#" and following would be interpreted as a comment.
          frame_color = "#3B7C87";
          foreground = "#3B7C87";
          background = "#191311";
          #background = "#2B313C";
          timeout = 4;
        };

        urgency_normal = {
          frame_color = "#5B8234";
          foreground = "#5B8234";
          background = "#191311";
          #background = "#2B313C";
          timeout = 6;
        };

        urgency_critical = {
          frame_color = "#B7472A";
          foreground = "#B7472A";
          background = "#191311";
          #background = "#2B313C";
          timeout = 8;
        };
      };
    };

    programs.kitty = {
      enable = true;
      keybindings = {
        "ctrl+shift+h" = "previous_tab";
        "ctrl+shift+l" = "next_tab";
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

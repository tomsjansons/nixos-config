# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }@inputs:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # nixpkgs.overlays = [
  #   (import (builtins.fetchTarball {
  #     url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
  #   }))
  # ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.extraHosts = ''
    127.0.0.1   zini.local
    127.0.0.1   hub.zini.local
    127.0.0.1   one.zini.local
    127.0.0.1   two.zini.local
    127.0.0.1   zini-two.local
  '';

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.iwd.enable = true;

  programs.git = {
    enable = true;
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  services.blueman.enable = true;

  programs.thunar.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  # networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Riga";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "lv_LV.UTF-8";
    LC_IDENTIFICATION = "lv_LV.UTF-8";
    LC_MEASUREMENT = "lv_LV.UTF-8";
    LC_MONETARY = "lv_LV.UTF-8";
    LC_NAME = "lv_LV.UTF-8";
    LC_NUMERIC = "lv_LV.UTF-8";
    LC_PAPER = "lv_LV.UTF-8";
    LC_TELEPHONE = "lv_LV.UTF-8";
    LC_TIME = "lv_LV.UTF-8";
  };

  console.useXkbConfig = true;

  security.polkit.enable = true;
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
    };
  };

  # xdg.portal = {
  #   enable = true;
  #   wlr.enable = true;
  #   extraPortals = [
  #     pkgs.xdg-desktop-portal-wlr
  #     (pkgs.xdg-desktop-portal-gtk.override { 
  #       # Do not build portals that we already have. 
  #       buildPortalsInGnome = false; 
  #     }) 
  #   ];
  #   config = {
  #     common = {
  #       default = [
  #         "wlr"
  #         "gtk"
  #       ];
  #       "org.freedesktop.impl.portal.Secret" = [
  #         "gnome-keyring"
  #       ];
  #     };
  #   };
  # };

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };

  # for cosmic needs to be commented out - start
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd niri-session";
      };
    };
  };
  # for cosmic needs to be commented out - end

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  services.logind.lidSwitch = "suspend";
  services.logind.lidSwitchDocked = "ignore";
  services.logind.lidSwitchExternalPower = "suspend";

  hardware.brillo.enable = true;

  environment.xfce.excludePackages = with pkgs; [
    xfce.xfce4-terminal
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
    services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    # pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 113 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l toms -c 'amixer -q set Master toggle'"; }
      { keys = [ 114 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l toms -c 'amixer -q set Master 5%- unmute'"; }
      { keys = [ 115 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l toms -c 'amixer -q set Master 5%+ unmute'"; }
    ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.toms = {
    isNormalUser = true;
    description = "Toms Jansons";
    extraGroups = [ "networkmanager" "wheel" "docker" "input" "video" "libvirtd" ];
    packages = with pkgs; [
    ];
  };

  # for cosmic needs to be commented out - start
  services.tlp = {
    enable = true;
    settings = {
      USB_AUTOSUSPEND = 0;
    };
  };
  # for cosmic needs to be commented out - end

  services.thermald.enable = true;

  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  virtualisation.docker.enable = true;
	virtualisation.libvirtd.enable = true;
	programs.virt-manager.enable = true;
	# programs.dconf = {
	# 	enable = true;
	# 	settings = {
	# 		"org/virt-manager/virt-manager/connections" = {
	# 			autoconnect = ["qemu:///system"];
	# 			uris = ["qemu:///system"];
	# 		};
	# 	};
	# };

  nixpkgs.config.allowUnfree = true;

  services.dbus.packages = [ pkgs.blueman ];

  programs.steam = {
    enable = true;
  };

  # for niri
  services.gnome.gnome-keyring.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  programs.niri.enable = true;
  
  environment.systemPackages = let 
    xwayland-satellite = pkgs.callPackage ./xwayland-satellite.nix {};
    zed-fhs = pkgs.buildFHSUserEnv {
      name = "zed";
      targetPkgs = pkgs:
        with pkgs; [
          zed-editor
        ];
      runScript = "zed";
    };
  in
  with pkgs; [
		youtube-tui
		spotify-player
    jetbrains.rust-rover
    vscode-extensions.vadimcn.vscode-lldb
    erdtree
    prs
    cyme
    xwayland
    impala
    lua-language-server
    prettierd
    eslint_d
    biome
    bun
    swayidle
    swaylock
    swaybg
    # niri
    xwayland-satellite
    # xdg-desktop-portal-gtk
    # xdg-desktop-portal-wlr
    zed-fhs
    neovide
    calc
    tidal-hifi
    zoom-us
    # yazi start
    ffmpegthumbnailer
    unar 
    poppler
    fd
    zoxide
    wl-clipboard
    ueberzugpp
    mediainfo
    exiftool
    # yazi end
    thunderbird
    just
    jq
    eza
    gpxsee
    firefox
    vlc
    lapce
    libnotify
    acpi
    gimp
    gnome.gucharmap
    nix-prefetch-github
    grc
    tldr
    zip
    xdg-user-dirs
    ksnip
    grim
    slurp
    swaynotificationcenter
    polkit_gnome
    busybox
    playerctl 
    onlyoffice-bin
    corefonts
    rust-analyzer
    rustfmt
    lazydocker
    lazygit
    ripgrep
    rustc
    brave
    cargo
    cargo-watch
    cargo-cranky
    sqlx-cli
    rambox
    slack
    discord
    gzip
    file
    _1password
    _1password-gui
    tmux
    spotify
    # libgcc
    # cl
    # zig
    rocmPackages.llvm.clang
    wget
    fira-code-nerdfont
  ];


  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "toms" ];
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  programs.git = {
    enable = true;
  };

  programs.thunar.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "lv";
    xkbVariant = "apostrophe";
    xkbOptions = "caps:swapescape";

    # excludePackages = [ pkgs.xterm ];

    # desktopManager = {
    #   xterm.enable = false;
    #   xfce = {
    #     enable = true;
    #     noDesktop = true;
    #     enableXfwm = false;
    #   };
    # };
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    displayManager.defaultSession = "none+i3";
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        i3lock-fancy
        lxappearance
      ];
    };
  };

  programs.hyprland = {
    enable = true;
  };

  hardware.brillo.enable = true;

  environment.xfce.excludePackages = with pkgs; [
    xfce.xfce4-terminal
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.toms = {
    isNormalUser = true;
    description = "Toms Jansons";
    extraGroups = [ "networkmanager" "wheel" "docker" "input" "video" ];
    packages = with pkgs; [
    ];
 };

  programs.zsh = {
    enable = true;
    shellAliases = {
      nixconf = "cd /etc/nixos && sudo -E nvim"; 
      nixupd = "sudo nixos-rebuild switch --impure";
      nixsh = "nix-shell --command zsh";
      nixshp = "nix-shell --command zsh -p";
    };
    histSize = 10000;
    ohMyZsh = {
      enable = true;
      plugins = [ 
        "git" 
        "npm"
        # {
        # will source zsh-autosuggestions.plugin.zsh
        # name = "zsh-npm-scripts-autocomplete";
	# src = "git@github.com:grigorii-zander/zsh-npm-scripts-autocomplete.git";
        # src = pkgs.fetchFromGitHub {
        #   owner = "grigorii-zander";
        #   repo = "zsh-npm-scripts-autocomplete";
	#   rev = "v0.0.1";
	#   sha256 = "5d145e13150acf5dbb01dac6e57e57c357a47a4b";
        # };
        # }
      ];
      theme = "robbyrussell";
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      nixconf = "cd /etc/nixos && sudo -E nvim"; 
      nixupd = "sudo nixos-rebuild switch --impure";
      nixsh = "nix-shell --command zsh";
      nixshp = "nix-shell --command zsh -p";
    };
  };

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

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    xdg-user-dirs
    ksnip
    grim
    slurp
    swaynotificationcenter
    xdg-desktop-portal-hyprland
    polkit-kde-agent
    busybox
    # toybox # used for polybar startup, maybe not needed?
    # xorg.xrandr # used for polybar startup, maybe not needed?
    playerctl 
    # xorg.xbacklight # i3 brightness key control
    pandoc # pandoc converts docs for obsidian plugin
    onlyoffice-bin
    corefonts
    rust-analyzer
    rustfmt
    lazydocker
    lazygit
    ripgrep
    obsidian
    rustc
    brave
    vivaldi
    vivaldi-ffmpeg-codecs
    cargo
    cargo-watch
    cargo-cranky
    sqlx-cli
    rambox
    slack
    beekeeper-studio
    discord
    awscli2
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

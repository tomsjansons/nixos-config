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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.xkbOptions = "caps:swapescape";

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "lv";
    xkbVariant = "apostrophe";
  };

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
    pulse.enable = true;
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
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.toms = {
    isNormalUser = true;
    description = "Toms Jansons";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox
      kate
    #  thunderbird
    ];
 };

  programs.zsh = {
    enable = true;
    shellAliases = {
      nixconf = "cd /etc/nixos && sudo -E nvim"; 
      nixupd = "sudo nixos-rebuild switch --impure";
      nixtest = "sudo nixos-build test --impure";
    };
    histSize = 10000;
    ohMyZsh = {
      enable = true;
      plugins = [ 
        "git" 
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

  users.defaultUserShell = pkgs.zsh;

  virtualisation.docker.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    rust-analyzer
    lazydocker
    lazygit
    ripgrep
    obsidian
    rustc
    cargo
    cargo-watch
    cargo-cranky
    sqlx-cli
    rambox
    slack
    beekeeper-studio
    discord
    neovim
    xclip
    awscli2
    gzip
    file
    brave
    _1password
    _1password-gui
    tmux
    spotify
    libgcc
    cl
    zig
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

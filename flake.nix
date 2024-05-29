{
  inputs = { 
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs"; 
    };
    helix.url = "github:helix-editor/helix";
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?ref=refs/tags/v0.40.0&submodules=1";
    # hyprscroller = {
    #   url = "github:dawsers/hyprscroller";
    #   inputs.hyprland.follows = "hyprland";
    # };
    hyprlock.url = "github:hyprwm/hyprlock";
    yazi.url = "github:sxyazi/yazi";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { 
    self, 
    nixpkgs, 
    helix, 
    ... 
  }@attrs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./configuration.nix ./home-manager.nix ];
    };
  };
}

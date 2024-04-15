{
  inputs = { 
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs"; 
    };
    helix.url = "github:helix-editor/helix";
    hyprlock.url = "github:hyprwm/hyprlock";
  };

  outputs = { self, nixpkgs, helix, ... }@attrs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./configuration.nix ./home-manager.nix ];
    };
  };
}

{
  inputs = { 
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; 
    };
    helix.url = "github:helix-editor/helix";
    yazi.url = "github:sxyazi/yazi";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # nixos-cosmic = {
    #   url = "github:lilyinstarlight/nixos-cosmic";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      modules = [ 
        # {
        #   nix.settings = {
        #     substituters = [ "https://cosmic.cachix.org/" ];
        #     trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
        #   };
        # }
        # attrs.nixos-cosmic.nixosModules.default
        attrs.niri.nixosModules.niri
        ./configuration.nix 
        ./home-manager.nix
        # ./cosmic.nix
      ];
    };
  };
}

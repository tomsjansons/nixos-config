
# default.nix
with import <nixpkgs> {};
stdenv.mkDerivation {
    name = "neovim-config"; # Probably put a more meaningful name here
    buildInputs = [ nodejs_21 steam-run ];
}

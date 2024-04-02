# default.nix
with import <nixpkgs> {};
stdenv.mkDerivation {
    name = "nix-conf-dir"; # Probably put a more meaningful name here
    buildInputs = [lua-language-server];
}

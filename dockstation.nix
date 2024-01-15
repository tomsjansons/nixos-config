  { pkgs, ... }:

  pkgs.appimageTools.wrapType2 { # or wrapType1
    name = "dockstation"; 
    src = pkgs.fetchurl {
      url = "https://github.com/DockStation/dockstation/releases/download/v1.5.1/dockstation-1.5.1-x86_64.AppImage";
    };
    extraPkgs = pkgs: with pkgs; [ ];
  }

{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "codecrafters-cli-${version}";
  version = "25";

  # https://github.com/codecrafters-io/cli/releases
  src = fetchurl {
    url =
    "https://github.com/codecrafters-io/cli/releases/download/v29/v29_linux_amd64.tar.gz";
    sha256 = "589136a38b6fabd5b37d62185d727680815fd3b17947b096881a817e7364b80a";
  };

  unpackPhase = ''
    mkdir -p $out
    tar -xzvf ${src}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r . $out/bin/
  '';
}

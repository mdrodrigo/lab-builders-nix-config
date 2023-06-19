{ pkgs, ... }:

{
  host-scripts = pkgs.stdenv.mkDerivation {
    name = "host-scripts";
    src = ../scripts;
    installPhase = ''
      mkdir -p $out/bin
      cp -r * $out/bin
    '';
  };
}

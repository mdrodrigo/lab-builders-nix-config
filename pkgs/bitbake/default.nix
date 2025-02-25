{ lib
, nix-update-script
, python3
, python3Packages
, fetchFromGitHub
}:

let
  mkBitbake = { version, hash, ... }@attrs:
    let
      attrs' = builtins.removeAttrs attrs [ "version" "hash" ];
    in
    python3Packages.buildPythonApplication
      (rec{
        pname = "bitbake";
        inherit version;
        pyproject = false;

        src = fetchFromGitHub {
          owner = "openembedded";
          repo = pname;
          rev = "${version}";
          inherit hash;
        };

        passthru.updateScript = nix-update-script { };

        installPhase = ''
          mkdir -p $out/lib
          cp -r $src/lib $out
          cp -r $src/bin $out
        '';

        meta = with lib; {
          description = "Bitbake";
          mainProgram = "bitbake";
          homepage = "https://github.com/openembedded/bitbake";
          license = lib.licenses.gpl2;
          maintainers = [ lib.maintainers.otavio ];
        };
      } // attrs');
in
rec {
  bitbake_2_8_7 = mkBitbake {
    version = "2.8.7";
    hash = "sha256-Pk/s4Drdw8ZAFb1Wn7RkAHoy2ZH3R2H3WPL1JD7ZEmA=";
  };

  bitbake_2_10_2 = mkBitbake {
    version = "2.10.2";
    hash = "sha256-cLlJkGva00m4L67AoHQQi3k2SSLSTbtF34WMDz8AKK4=";
  };
}

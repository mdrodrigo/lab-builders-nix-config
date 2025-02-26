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
          changelog = "https://github.com/Freed-Wu/bitbake-language-server/releases/tag/${version}";
          license = lib.licenses.gpl3;
          maintainers = [ lib.maintainers.otavio ];
        };
      } // attrs');
in
rec {
  bitbake_2_8 = mkBitbake {
    version = "2.8";
    hash = "sha256-IKUBQtMzP1YgXN+hgcm1hOboeZTe47kHJVq7oH1oyYQ=";
  };

  bitbake_2_10 = mkBitbake {
    version = "2.10";
    hash = "sha256-IKUBQtMzP1YgXN+hgcm1hOboeZTe47kHJVq7oH1oyYQ=";
  };
}

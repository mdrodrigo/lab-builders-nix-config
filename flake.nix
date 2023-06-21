{
  description = "Otavio Salvador's NixOS/Home Manager config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixos-hardware.url = "nixos-hardware";
    disko.url = "github:nix-community/disko";

    # users
    users-otavio.url = "github:otavio/nix-config";
  };

  outputs = { self, ... }@inputs:
    let
      inherit (self) outputs;
      lib = import ./lib { inherit inputs outputs; };
    in
    {
      overlays = import ./overlays { inherit inputs outputs; };

      nixosConfigurations = {
        centrium = lib.mkSystem {
          hostname = "centrium";
          system = "x86_64-linux";
        };

        hyper = lib.mkSystem {
          hostname = "hyper";
          system = "x86_64-linux";
        };

        pikachu = lib.mkSystem {
          hostname = "pikachu";
          system = "x86_64-linux";
        };
      };

      packages = builtins.foldl'
        (packages: hostname:
          let
            inherit (self.nixosConfigurations.${hostname}.config.nixpkgs) system;
            targetConfiguration = self.nixosConfigurations.${hostname};
          in
          packages // {
            ${system} = (packages.${system} or { }) // {
              "${hostname}-install-iso" = lib.mkInstallerForSystem { inherit hostname targetConfiguration system; };
            };
          })
        { }
        (builtins.attrNames self.nixosConfigurations);
    } // inputs.flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        inherit (self) outputs;
        pkgs = import inputs.nixpkgs { inherit system outputs; };
      in
      {
        formatter = pkgs.writeShellApplication {
          name = "normalise_nix";
          runtimeInputs = with pkgs; [ nixpkgs-fmt statix ];
          text = ''
            set -o xtrace
            nixpkgs-fmt "$@"
            statix fix "$@"
          '';
        };

        checks = {
          lint = pkgs.runCommand "lint-code" { nativeBuildInputs = with pkgs; [ nixpkgs-fmt deadnix statix ]; } ''
            deadnix --fail ${./.}
            #statix check ${./.} # https://github.com/nerdypepper/statix/issues/75
            nixpkgs-fmt --check ${./.}
            touch $out
          '';
        };
      });
}

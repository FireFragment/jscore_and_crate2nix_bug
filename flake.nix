{
  # ...

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    crate2nix.url = "github:nix-community/crate2nix";
    # ...
  };

  outputs =
    inputs @ { self
    , nixpkgs
    , flake-parts
    , crate2nix
    , ...
    }: flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem = { system, pkgs, lib, inputs', ... }: let

          cargoNix = inputs.crate2nix.tools.${system}.appliedCargoNix {
            name = "crate2nix-bug";
            src = ./.;
          };
        in {
          packages.default = cargoNix.rootCrate.build;
        };
    };
}

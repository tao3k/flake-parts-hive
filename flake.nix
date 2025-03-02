{
  description = "A flake parts with omnibus example";

  inputs = {
    nixos-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.follows = "nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    omnibus.url = "github:tao3k/omnibus";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake =
        let
          hive = inputs.omnibus.pops.hive.setHosts (
            inputs.omnibus.load {
              src = ./hosts;
              inputs = {
                inherit inputs;
              };
            }
          );
        in
        {
          inherit (hive.exports)
            nixosConfigurations
            homeConfigurations
            darwinConfigurations
            colmenaHive
            ;
        };
      imports = [
        ./modules/flake-parts/packagesExtensible.nix
        (
          { withSystem, ... }:
          {
            flake.overlays.default =
              final: prev:
              withSystem prev.stdenv.hostPlatform.system (
                # perSystem parameters. Note that perSystem does not use `final` or `prev`.
                { config, ... }: config.packagesExtensible.overlays.default
              );
            flake.overlays.composedPackages =
              final: prev:
              withSystem prev.stdenv.hostPlatform.system (
                # perSystem parameters. Note that perSystem does not use `final` or `prev`.
                { config, ... }: config.packagesExtensible.overlays.composedPackages
              );
          }
        )
      ];
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          system,
          pkgs,
          ...
        }:
        let
          packagesExporter =
            (import ./packages {
              inherit system inputs pkgs;
            }).exports;
        in
        {

          _module.args.pkgs = import inputs.nixos-unstable {
            inherit system;
            overlays = [ ];
            config.allowUnfree = true;
          };
          packagesExtensible = packagesExporter.packages // {
            overlays = packagesExporter.overlays;
          };
          packages = packagesExporter.derivations;
        };
    };
}

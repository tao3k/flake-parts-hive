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
      imports = [
        ./modules/flake-parts/omnibus-hive.nix
        ./modules/flake-parts/omnibus-packages.nix
        (
          { config, ... }:
          {
            omnibus.pops.hive = {
              src = ./hosts;
            };
            # load the nixosConfigurations with the custom attribute
            flake.nixosConfigurations =
              (config.omnibus.pops.hive.setNixosConfigurationsRenamer "customNixOS").exports.nixosConfigurations;
          }
        )
      ];
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
        "aarch64-linux"
      ];
      perSystem =
        {
          system,
          pkgs,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixos-unstable {
            inherit system;
            overlays = [ ];
            config.allowUnfree = true;
          };
          omnibus.pops.packages = {
            src = ./packages/__fixture;
          };
        };
    };
}

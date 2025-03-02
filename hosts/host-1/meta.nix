# SPDX-FileCopyrightText: 2024 The omnibus Authors
#
# SPDX-License-Identifier: MIT
{
  lib,
  self,
  inputs,
  nixosModules,
}:
{

  system = "x86_64-linux";
  nixosConfiguration = {
    bee.pkgs = import inputs.nixos-unstable { system = self.system; };
    bee.system = self.system;
    bee.home = inputs.omnibus.flake.inputs.home-manager;
    imports = [
      inputs.self.nixosProfiles.presets.boot
      inputs.omnibus.flake.inputs.disko.nixosModules.default
    ];
  };
  colmenaConfiguration = {
    deployment = {
      allowLocalDeployment = true;
      targetHost = "127.0.0.1";
    };
    inherit (self.nixosConfiguration) bee imports;
  };
}

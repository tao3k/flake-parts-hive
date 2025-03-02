{ flake, pkgs, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  nixos-unified.sshTarget = "srid@hello";

  imports = [ ];

  networking.hostName = "hello";

  environment.systemPackages = with pkgs; [
    neovim
  ];
}

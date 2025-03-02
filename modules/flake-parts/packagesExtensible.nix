{
  lib,
  flake-parts-lib,
  ...
}:
let
  inherit (lib)
    types
    ;
  inherit (flake-parts-lib)
    mkTransposedPerSystemModule
    ;
in
mkTransposedPerSystemModule {
  name = "packagesExtensible";
  option = lib.mkOption {
    type = types.lazyAttrsOf types.unspecified;
    default = { };
    description = "Packages to be exported with the extensible attribute";
  };
  file = ./packagesExtensible.nix;
}

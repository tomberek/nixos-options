{
  inputs.nixpkgs.url = "nixpkgs";
  outputs = {
    self,
    nixpkgs,
  }: let
    processOption = value: let
      res =
        (value.type.getSubOptions [])
        // {
          description = value.description.text or value.description or "";
          default = value.default or null;
          example = value.example or null;
        };
    in
      process (builtins.removeAttrs res ["_module"]);

    # A "switch" statement to avoid tons of if-then-else
    process = {
      "option" = value: processOption value;
      "submodule" = value: processOption value;
      "set" = value: builtins.mapAttrs (n: v: process v) value;
      "derivation" = value: "derivation: ${value.name}";
      "list" = value: map process value;
      "lambda" = value: "lambda";
      __functor = self: x: let
        smartType =
          if nixpkgs.lib.isDerivation x
          then "derivation"
          else x._type or (builtins.typeOf x);
      in
        (self."${smartType}" or (_: _)) x;
    };
  in
    process
    (import "${nixpkgs}/nixos" {
      configuration = {};
      system = "x86_64-linux"; # dummy parameter to avoid impure
    })
    .options;
}

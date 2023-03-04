{
  inputs.nixpkgs.url = "nixpkgs";
  outputs = {
    self,
    nixpkgs,
  }: let
    processOption = value: path: let
      res =
        (value.type.getSubOptions [])
        // {
          description = value.description.text or value.description or "";
          default = value.default or null;
          example = value.example or null;
        };
    in
      process (builtins.removeAttrs res ["_module"]) path;

    # A "switch" statement to avoid tons of if-then-else
    process = {
      "option" = value: path: processOption value path;
      "submodule" = value: path: processOption value path;
      "set" = value: path: builtins.mapAttrs (n: v: process v (path ++ [n])) value;
      "derivation" = value: path: "derivation: ${value.name}";
      "list" = value: path: map (v: process v path) value;
      "lambda" = value: path: "lambda";
      __functor = self: x: path: let
        smartType =
          builtins.unsafeDiscardStringContext
          (
            if nixpkgs.lib.isDerivation x
            then "derivation"
            else x._type or (builtins.typeOf x)
          );
      in
        if path == ["services" "networking" "websockify" "sslKey"]
        then "redacted"
        else (self."${smartType}" or (a: b: a)) x path;
    };
  in
    process
    (import "${nixpkgs}/nixos" {
      configuration = {};
      system = "x86_64-linux"; # dummy parameter to avoid impure
    })
    .options [];
}

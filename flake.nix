{
  inputs.nixpkgs.url = "nixpkgs";
  outputs = {
    self,
    nixpkgs,
  }: 
    let
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
      process = {
        "option" = value: processOption value;
        "submodule" = value: processOption value;
        "set" = value: let
          res = builtins.mapAttrs (n: v: process v) value;
        in
          res;
        "string" = value: value;
        "lambda" = value: "lambda";
        __functor = self: x: let
          smartType = x._type or (builtins.typeOf x);
        in
          (self."${smartType}" or (_: _)) x;
      };
    in
    process (import "${nixpkgs}/nixos" {
      configuration = {};
      system = "x86_64-linux";
    }).options;
}

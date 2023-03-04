# nixos-option

Using nix itself to explore NixOS options. Showcases using a `__functor` as a switch statement, recursive calls, and type-based dispatch.

## Example

```shell
nix eval github:tomberek/nixos-options#services.postgresql.extraPlugins --json | jq
```
```json
{
  "default": [],
  "description": "List of PostgreSQL plugins. PostgreSQL version for each plugin should\nmatch version for `services.postgresql.package` value.\n",
  "example": {
    "_type": "literalExpression",
    "text": "with pkgs.postgresql_11.pkgs; [ postgis pg_repack ]"
  }
}
```

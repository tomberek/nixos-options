# nixos-option

Using nix itself to explore NixOS options. Showcases using a `__functor` as a switch statement, recursive calls, and type-based dispatch.

## Example

```shell
nix eval github:tomberek/nixos-options#services.openssh.settings.Ciphers --json | jq
```
```json
{
  "default": [
    "chacha20-poly1305@openssh.com",
    "aes256-gcm@openssh.com",
    "aes128-gcm@openssh.com",
    "aes256-ctr",
    "aes192-ctr",
    "aes128-ctr"
  ],
  "description": "Allowed ciphers\n\nDefaults to recommended settings from both\n<https://stribika.github.io/2015/01/04/secure-secure-shell.html>\nand\n<https://infosec.mozilla.org/guidelines/openssh#modern-openssh-67>\n",
  "example": null
}
```

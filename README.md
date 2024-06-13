# nix-flakes

## zellij

```nix
{
  # flake
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    zellij = {
      url = "github:towry/nix-flakes?dir=zellij";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  }
}
```

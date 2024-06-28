# nix-flakes

## templates

Init in current dir:

```
nix flake init --template github:towry/nix-flakes#<template-name>
```

Init with new dir:

```
nix flake new --template github:towry/nix-flakes#<template-name>
```

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

{
  description = "Zellij head";
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=24.05";
  outputs = {
    self,
    nixpkgs,
  }: {
    packages = builtins.listToAttrs (
      map
      (
        system:
          with import nixpkgs {inherit system;}; {
            name = system;
            value = {
              default = zellij.overrideAttrs (attrs: rec {
                pname = "zellij";
                version = "0.41.0";
                src = fetchFromGitHub {
                  owner = "towry";
                  repo = "zellij";
                  rev = "fe30f08575c91f31a3a883195f44ffbb8b842769";
                  hash = "sha256-lfHNMcgEdfiqZPcmGe0A5nmOfws1luAwtBsFdC8X4O0=";
                };
                cargoDeps = zellij.cargoDeps.overrideAttrs (
                  lib.const {
                    name = "${pname}-vendor.tar.gz";
                    inherit src;
                    outputHash = "sha256-fVXt/9ygm4vJ0XfLl5o0/Ki4mvAkq9f4PtZjxzgny1s=";
                  }
                );
                buildInputs =
                  zellij.buildInputs
                  ++ [
                    openssh
                    pkg-config
                    perl
                  ];
                nativeBuildInputs =
                  zellij.nativeBuildInputs
                  ++ [
                    openssh
                    pkg-config
                    perl
                  ];
              });
            };
          }
      )
      [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ]
    );
  };
}

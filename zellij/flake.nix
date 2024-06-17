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
                  rev = "910d657f4e93a320a814e17b5d717b088d86c417";
                  hash = "sha256-pcrNsqPj17gOp6brFC6pSyUL0rGqtaWHScbfTSGG1l0=";
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

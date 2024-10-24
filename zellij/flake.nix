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
                version = "0.42.1";
                src = fetchFromGitHub {
                  owner = "pze";
                  repo = "zellij";
                  rev = "a71b18327a82768dd779c0d8f71c0263642c4861";
                  hash = "sha256-rcgNPSE1xSff1dl/ow57EWivG41/AuuEi2sLUjvr0mg=";
                };
                cargoDeps = rustPlatform.importCargoLock {
                  lockFile = ./Cargo.lock;
                };
                buildInputs =
                  zellij.buildInputs
                  ++ [
                    curl
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

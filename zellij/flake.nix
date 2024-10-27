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
              default = zellij.overrideAttrs (_attrs: rec {
                pname = "zellij";
                version = "0.42.3";
                src = fetchFromGitHub {
                  owner = "pze";
                  repo = "zellij";
                  rev = "b99cb29e4917651d9a6bcb38b574ac9ecc33ddc3";
                  hash = "sha256-cPcDjcw6M3AL6JoI2DuuN3RHiiJZCtIX0JjQPUVsN1Q=";
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

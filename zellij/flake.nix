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
                  rev = "912c9f599f33709b80c78582d7f0e3f3abe18889";
                  hash = "sha256-iItIv1ni+GxYilf4l6zz6tCuUeTyw5DcLUrP9otr/oM=";
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

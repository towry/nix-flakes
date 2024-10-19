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
                version = "0.42.0";
                src = fetchFromGitHub {
                  owner = "pze";
                  repo = "zellij";
                  rev = "eb4b7fc1072ea1b31c62a702d3a3bd722966eb89";
                  hash = "sha256-b3sh0gM3bJvDVEC/W3Fr/3CnvQ35fY6v7mvOgjTGrhI=";
                };
                cargoDeps = zellij.cargoDeps.overrideAttrs (
                  lib.const {
                    name = "${pname}-vendor.tar.gz";
                    inherit src;
                    outputHash = "sha256-Sp2TaUc1ybe/Ii/5vJAXpeTjCMpopU5B8P98Sm8xbKU=";
                  }
                );
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

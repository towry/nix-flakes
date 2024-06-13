{
  description = "Zellij head";
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
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
                  owner = "zellij-org";
                  repo = "zellij";
                  rev = "883855587c4c963f3037f287e5239e8cd297ab69";
                  hash = "sha256-UM+Q371ZuAIJSphwUvLBchm7cS0sS5EfuWYN/W0cwZE=";
                };
                cargoDeps = zellij.cargoDeps.overrideAttrs (
                  lib.const {
                    name = "${pname}-vendor.tar.gz";
                    inherit src;
                    outputHash = "sha256-KkAU797oq7AFpKqGgyISqy+6CdM/yoFjRZjhwLJsXYs=";
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

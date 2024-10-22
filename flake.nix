{
  description = "towry De flakes";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    overlays = [
      (final: _: let
        getSystem = "SYSTEM=$(nix eval --impure --raw --expr 'builtins.currentSystem')";
        forEachDir = exec: ''
          for dir in */; do
            (
              cd "''${dir}"

              ${exec}
            )
          done
        '';
      in {
        format = final.writeShellApplication {
          name = "format";
          runtimeInputs = with final; [alejandra];
          text = "alejandra '**/*.nix'";
        };
        build = final.writeShellApplication {
          name = "build";
          text = forEachDir ''
            ${getSystem}
            echo "> ================================="
            echo "run build in dir: ''${dir}"
            nix build --show-trace ".#packages.''${SYSTEM}.default"
          '';
        };
        check = final.writeShellApplication {
          name = "check";
          text = forEachDir ''
            ${getSystem}
            echo "checking ''${dir}"
            nix flake check --system "''${SYSTEM}" --show-trace
          '';
        };
        update = final.writeShellApplication {
          name = "update";
          text = forEachDir ''
            echo "updating ''${dir}"
            nix flake update
          '';
        };
      })
    ];
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit overlays system;};
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [build check format update alejandra];
      };
    });
    templates = {
      rust-workspace = {
        path = ./rust-workspace;
        description = "rust workspace project template";
      };
    };
  };
}

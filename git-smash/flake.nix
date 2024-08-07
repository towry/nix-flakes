{
  description = "git-smash";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=24.05";
    flake-utils.url = "github:numtide/flake-utils";
    fenix.url = "github:nix-community/fenix/monthly";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
    naersk.url = "github:nix-community/naersk";
    naersk.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    # self,
    nixpkgs,
    fenix,
    naersk,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (_: super: let pkgs' = fenix.inputs.nixpkgs.legacyPackages.${super.system}; in fenix.overlays.default pkgs' pkgs')
        ];
      };
      supportedPlatforms = {
        aarch64-darwin = {
          rustTarget = "aarch64-apple-darwin";
        };
        aarch64-linux = {
          rustTarget = "aarch64-unknown-linux-gnu";
        };
        x86_64-darwin = {
          rustTarget = "x86_64-apple-darwin";
        };
        x86_64-linux = {
          rustTarget = "x86_64-unknown-linux-gnu";
        };
      };
      rustTarget = supportedPlatforms.${system}.rustTarget;
      apple_sdk = pkgs.darwin.apple_sdk.frameworks;
      rust-toolchain = with pkgs.fenix;
        combine [
          stable.cargo
          stable.rustc
          stable.rustfmt
          stable.clippy
          targets.${rustTarget}.stable.rust-std
          # targets.wasm32-wasi.stable.rust-std
        ];
      naersk' = pkgs.callPackage naersk {
        cargo = rust-toolchain;
        rustc = rust-toolchain;
      };
      buildInputs =
        [pkgs.openssl pkgs.bashInteractive pkgs.libiconv]
        ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [pkgs.libiconv apple_sdk.DiskArbitration apple_sdk.Foundation apple_sdk.Security apple_sdk.SystemConfiguration];
    in {
      packages.default = naersk'.buildPackage {
        src = pkgs.fetchFromGitHub {
          owner = "anthraxx";
          repo = "git-smash";
          rev = "9e9c54e3132cb7d5afe8f4a7848dc0606b2f2c95";
          hash = "sha256-Pq1erkeF0QS8IFikG4Tpfuztp888Y490lJ83EWX4BHQ=";
        };
        buildInputs = buildInputs;
        nativeBuildInputs = [
          pkgs.pkg-config
        ];
      };
    });
}

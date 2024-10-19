all:
  just --list

# Format nix files
fmt:
  alejandra ./**/*.nix

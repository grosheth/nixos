{ ... }:
{
  imports = [
    ./packages/languages/lang.nix
    ./packages/languages/python.nix
    ./packages/languages/rust.nix
    ./packages/languages/go.nix
    ./packages/tools/tools.nix
  ];
}

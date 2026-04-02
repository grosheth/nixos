{ config, pkgs, ... }:
let
  k8sRoot = "${config.home.homeDirectory}/nixos/k8s";
in
{
  home.sessionVariables.K8S_ROOT = k8sRoot;

  home.packages = with pkgs; [
    (writeShellScriptBin "k8s-apply" (builtins.readFile ../k8s/scripts/k8s-apply.sh))
    (writeShellScriptBin "k8s-diff" (builtins.readFile ../k8s/scripts/k8s-diff.sh))
    (writeShellScriptBin "k8s-render" (builtins.readFile ../k8s/scripts/k8s-render.sh))
  ];
}

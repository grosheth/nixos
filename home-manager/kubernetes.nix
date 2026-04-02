{ config, lib, pkgs, ... }:
let
  k8sRoot = "${config.home.homeDirectory}/nixos/k8s";
in
{
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  sops.secrets.kubeconfig = {
    sopsFile = ./secrets/kubeconfig.sops.yaml;
    path = "${config.home.homeDirectory}/.kube/config";
    mode = "0600";
    format = "yaml";
  };

  home.sessionVariables = {
    KUBECONFIG = "${config.home.homeDirectory}/.kube/config";
    K8S_ROOT = k8sRoot;
  };

  home.packages = with pkgs; [
    (writeShellScriptBin "k8s-apply" (builtins.readFile ../k8s/scripts/k8s-apply.sh))
    (writeShellScriptBin "k8s-delete" (builtins.readFile ../k8s/scripts/k8s-delete.sh))
    (writeShellScriptBin "k8s-diff" (builtins.readFile ../k8s/scripts/k8s-diff.sh))
    (writeShellScriptBin "k8s-list" (builtins.readFile ../k8s/scripts/k8s-list.sh))
    (writeShellScriptBin "k8s-render" (builtins.readFile ../k8s/scripts/k8s-render.sh))
  ];
}

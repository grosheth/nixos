{ config, lib, pkgs, ... }:
{
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  sops.secrets.kubeconfig = {
    sopsFile = ./secrets/kubeconfig.sops.yaml;
    path = "${config.home.homeDirectory}/.kube/config";
    mode = "0600";
    format = "yaml";
  };

  home.sessionVariables.KUBECONFIG = "${config.home.homeDirectory}/.kube/config";
}

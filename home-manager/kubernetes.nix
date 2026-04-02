{ config, lib, pkgs, ... }:
{
  sops = {
    defaultSopsFile = ./secrets/kubeconfig.sops.yaml;
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };

  sops.secrets.kubeconfig = {
    path = "${config.home.homeDirectory}/.kube/config";
    mode = "0600";
    format = "yaml";
  };

  home.sessionVariables.KUBECONFIG = "${config.home.homeDirectory}/.kube/config";
}

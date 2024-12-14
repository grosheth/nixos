{ pkgs ? import <nixpkgs> {} }:
pkgs.callPackage ./work/ssh-manager.nix {}

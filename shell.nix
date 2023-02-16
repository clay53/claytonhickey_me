{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell rec {
    buildInputs = with pkgs; [
        rustup
        cargo
    ];
    HISTFILE = toString ./.history;
}
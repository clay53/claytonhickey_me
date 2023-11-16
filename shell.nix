{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
    buildInputs = with pkgs; [
        webfs
        nodePackages.typescript-language-server
        nodePackages.vscode-css-languageserver-bin
        nodePackages.vscode-json-languageserver-bin
        nodePackages.vscode-html-languageserver-bin
    ];
}

{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
    buildInputs = with pkgs; [
        webfs
        nodePackages.typescript-language-server
        nodePackages.vscode-css-languageserver-bin
        nodePackages.vscode-json-languageserver-bin
        nodePackages.vscode-html-languageserver-bin
        ocamlPackages.odoc
        ocamlPackages.ocaml-lsp
        dune_3
        ocaml
        inotify-tools
        ocamlPackages.findlib
        ocamlPackages.lambdasoup
        ocamlformat
    ];

    TOPFIND = "${pkgs.ocamlPackages.findlib}/lib/ocaml/*/site-lib/topfind";
}

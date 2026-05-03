{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in
  {
    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = with pkgs; [
          webfs
          ocamlPackages.odoc
          dune_3
          ocaml
          inotify-tools
          ocamlPackages.findlib
          ocamlPackages.lambdasoup
          ocamlformat
      ];

      TOPFIND = "${pkgs.ocamlPackages.findlib}/lib/ocaml/*/site-lib/topfind";
    };
  };
}

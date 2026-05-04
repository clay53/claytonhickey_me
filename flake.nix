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

    packages.x86_64-linux.default = pkgs.stdenv.mkDerivation {
      name = "claytonhickey_me";
      version = "1.0.0";
      src = ./.;

      buildInputs = with pkgs; [
        dune_3
        ocaml
        ocamlPackages.findlib
        ocamlPackages.lambdasoup
      ];

      TOPFIND = "${pkgs.ocamlPackages.findlib}/lib/ocaml/*/site-lib/topfind";

      buildPhase = ''
        mkdir $out
        cp -r $src $out/build
        chmod -R +w $out/build
        cd $out/build
        dune build
        ocaml no_dune.ml
        mv $out/build/www $out/www
        rm -r $out/build
      '';
    };
  };
}

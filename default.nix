let
    pkgs = import <nixpkgs> {};
in
pkgs.stdenv.mkDerivation {
    pname = "claytonhickeyme";
    version = "wc3";
    src = ./.;

    buildPhase = ''
        cp "$src/www" -r "$out"
    '';
}

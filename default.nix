let
    pkgs = import <nixpkgs> {};
in
pkgs.stdenv.mkDerivation {
    pname = "claytonhickeyme";
    version = "wc2";
    src = ./.;

    buildPhase = ''
        cp "$src/www" -r "$out"
    '';
}

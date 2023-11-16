let
    pkgs = import <nixpkgs> {};
in
pkgs.stdenv.mkDerivation {
    pname = "claytonhickeyme";
    version = "wc1";
    src = ./.;

    buildPhase = ''
        cp "$src/www" -r "$out"
    '';
}

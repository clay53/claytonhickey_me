let
    pkgs = import <nixpkgs> {
        overlays = [
            (import (fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
        ];
    };
    rustPlatform = pkgs.makeRustPlatform {
        cargo = pkgs.rust-bin.nightly."2023-03-15".minimal;
        rustc = pkgs.rust-bin.nightly."2023-03-15".minimal;
    };

    builder = rustPlatform.buildRustPackage {
        pname = "claytonhickeyme-builder";
        version = "af167b803b4f58cb2b92415ff1f4ca5d7f33b73e";
        src = ./.;

        cargoLock = {
            lockFile = ./Cargo.lock;
            outputHashes = {
                "chrono-0.4.20-beta.1" = "sha256-7LlcYbWbO8Up3iHXRmtmIKMZmVG0ebB+q6+gM1fuA7A=";
            };
        };

        doCheck = false;

        meta = {
            description = "builds claytonhickey.me";
        };
    };
in
pkgs.stdenv.mkDerivation {
    pname = "claytonhickeyme";
    version = "af167b803b4f58cb2b92415ff1f4ca5d7f33b73e";
    src = ./.;

    buildPhase = ''
        echo "y" | DOMAIN="https://claytonhickey.me" WWW_DIR="$out" ${builder}/bin/claytonhickey_me
    '';
}

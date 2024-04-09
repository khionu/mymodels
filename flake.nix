{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    lib = nixpkgs.lib;
    eachSystem = f: lib.genAttrs systems (system: f rec {
      inherit system;
      pkgs = import nixpkgs { inherit system; };
    });
  in {
    packages = eachSystem ({ pkgs, system }: {
      libfiveStudio = { lib, fetchFromGitHub, stdenv, boost, cmake, eigen, pkg-config,
                        libpng, guile, python3, qt5 }:
        stdenv.mkDerivation (finalAttrs: {
          pname = "libfiveStudio";
          version = "248c15c57abd2b1b9ea0e05d0a40f579d225f00f";
          src = fetchFromGitHub {
            owner = "libfive";
            repo = "libfive";
            rev = "${finalAttrs.version}";
            hash = "sha256-WIw2n59sRIb77GEcVzq8TtTL69qlQLuX0/FqulLnI0E=";
          };
         
          doCheck = false;
          nativeBuildInputs = [
            boost
            cmake
            eigen
            pkg-config
            qt5.wrapQtAppsHook
          ];
         
          buildInputs = [
            guile
            python3
            qt5.qtbase
            libpng
          ];
        });
    });
    devShells = eachSystem ({ pkgs, system }: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          openscad-unstable
        ];
      };
    });
  };
}

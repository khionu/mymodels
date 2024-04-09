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
    devShells = eachSystem ({ pkgs, system }: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          openscad-unstable
        ];
      };
    });
  };
}

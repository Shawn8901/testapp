{
  description = "Application packaged using poetry2nix";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.poetry2nix.url = "github:nix-community/poetry2nix";

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      testappEnv = pkgs.poetry2nix.mkPoetryEnv {
        projectDir = ./.;
        editablePackageSources = {
          testapp = ./testapp;
        };
      };
    in
    {
      devShells.${ system}. default = testappEnv.env.overrideAttrs
        (oldAttrs: {
          buildInputs = [ pkgs.postgresql_11 ];
        });
    };
}

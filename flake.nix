{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    #nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
    #nixpkgs-cmdstan-2_17.url = "github:NixOS/nixpkgs/7be6cf9784aad8d3b0606fb469eaa528f21f2621";
    devenv.url = "github:cachix/devenv";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
      ];
      systems = ["x86_64-linux"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        dotnetCombined = with pkgs.dotnetCorePackages; combinePackages [sdk_7_0 aspnetcore_7_0 runtime_7_0];
        #stan-pkgs = import inputs.nixpkgs-cmdstan-2_17 {
        #  inherit system;
        #};
      in {
        packages = rec {
          # BROKEN: cannot get dependencies. Running into this error: https://github.com/NixOS/nixpkgs/issues/230519
          SlicStan = pkgs.callPackage ./. {};
          fetch-deps = SlicStan.passthru.fetch-deps;
          default = SlicStan;
        };
        devenv.shells.default = {
          packages = with pkgs; [dotnetCombined z3.dev cmdstan alejandra];
        };
      };
    };
}

{
  pkgs ?
    import (builtins.fetchGit {
      name = "nixos-dotnet_2.1.810";
      url = "https://github.com/nixos/nixpkgs/";
      rev = "1b97f5d00b97b42d3cde83763d4f4be990997ca2";
    }) {},
}:
with pkgs; let
  dotnetCombined = with dotnetCorePackages; combinePackages [sdk_2_1 sdk_3_1 aspnetcore_2_1 aspnetcore_3_1 netcore_2_1 netcore_3_1];
in
  mkShell {
    name = "dotnet-env";
    packages = [
      dotnetCombined
      z3
    ];
  }

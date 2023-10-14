{lib, buildDotnetModule, fetchFromGitHub, dotnetCorePackages, z3}:
let
  dotnetCombined = with dotnetCorePackages; combinePackages [sdk_7_0 aspnetcore_7_0 runtime_7_0];
in
buildDotnetModule rec {
  pname = "SlicStan";
  version = "1.0.0";

  src = ./.;

  projectFile = "SlicStan.sln";

  # to generate `nugetDeps`, start by adding a compatible test file like the following:
  #
  nugetDeps = builtins.toFile "test" "{...}: []";
  #
  # then running the following commands:
  #
  #   $ nix repl '<nixpkgs>'
  #   nix-repl> :b (callPackage ./default.nix {}).passthru.fetch-deps
  #   This derivation produced the following outputs:
  #     out -> /nix/store/4xpw2jic4iih7alimvdgjm0cgizvz2v2-fetch-SlicStan-deps
  #   $ /nix/store/4xpw2jic4iih7alimvdgjm0cgizvz2v2-fetch-SlicStan-deps
  #
  # even this is annoying and you need to build it in a release.nix (or flake.nix) to make
  # sure the incorrect runtime identifiers are not added to the .fsproj file.
  #nugetDeps = ./deps.nix;

  #dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-sdk = dotnetCombined;
  #nativeBuildInputs = [dotnetCombined];
  #dotnet-runtime = dotnetCorePackages.net_7_0;
  dotnetFlags = ["--runtime linux-x64"];
  runtimeDeps = [z3.dev];

  meta = with lib; {
    homepage = "https://github.com/mgorinova/SlicStan";
    description = "A Stan-like probabilistic programming language.";
    license = licenses.mit;
  };
}

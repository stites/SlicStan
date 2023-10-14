with (import <nixpkgs> {});
{
  ss = callPackage ./. {};
  deps = ss.passthru.fetch-deps;
}

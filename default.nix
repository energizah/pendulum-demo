let
  pkgs = import (builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "20.03";
    url = "https://github.com/nixos/nixpkgs/archive/20.03.tar.gz";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "0182ys095dfx02vl2a20j1hz92dx3mfgz2a6fhn31bqlp1wa8hlq";
  }) { };

  poetry2nix = pkgs.callPackage (pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "poetry2nix";
    rev = "f4ab52a42cc646b8b81dd0d6345be9f48c944ac9";
    sha256 = "1c4vf2w1sm63n9jdjr1yd32r99xq164hijqcac8lr6x6b03p3j57";
  }) { };

  nixpkgs-unstable = import (builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixpkgs-unstable";
    # Commit hash for nixos-unstable as of 2018-09-12
    url =
      "https://github.com/nixos/nixpkgs/archive/3c0e3697520cbe7d9eb3a64bfd87de840bf4aa77.tar.gz";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "sha256:1vx7kyaq0i287dragjgfdj94ggwr3ky2b7bq32l8rkd2k3vc3gl5";
  }) { };

in (poetry2nix.mkPoetryEnv {
  projectDir = ./.;

  # src = gitignoreSource.gitignoreSource ../.;
  overrides = poetry2nix.overrides.withDefaults (self: super: {

    pendulum = nixpkgs-unstable.python3Packages.pendulum.override {
      inherit (self) pytzdata dateutil;
    };

  });

})

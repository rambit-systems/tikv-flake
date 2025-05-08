{
  inputs = {
    flake-parts.url = "https://flakehub.com/f/hercules-ci/flake-parts/0.1.tar.gz";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } ({ ... }: {
    systems = [ "x86_64-linux" "aarch64-linux" ];
    imports = [
      ./flake-modules/tikv
    ];
  });
}

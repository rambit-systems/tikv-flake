{ ... }: {
  perSystem = { system, pkgs, ... }: let
    makeTikvBinary = (import ./makeTikvBinary.nix) { inherit system pkgs; };
    makeTikvDockerImage = (import ./makeTikvDockerImage.nix) { inherit pkgs; };

    version = "8.1.1";
    tikv = makeTikvBinary {
      name = "tikv";
      inherit version;
    };
    pd = makeTikvBinary {
      name = "pd";
      inherit version;
    };
  in {
    packages = {
      inherit tikv pd;
      tikv-image = makeTikvDockerImage {
        binary = tikv;
        pname = "tikv";
        version = "8.1.1";
      };
      pd-image = makeTikvDockerImage {
        binary = pd;
        pname = "pd";
        version = "8.1.1";
      };
    };
  };
}

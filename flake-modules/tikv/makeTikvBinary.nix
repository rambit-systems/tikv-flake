# this file is a function, which when called produces the function makeTikvBinary.
# the makeTikvBinary function pulls the binary with `name` out of the tikv bundle
{ pkgs, system, ... }: { name, version }: let
  pname = "${name}-server";

  arch = { x86_64-linux = "amd64"; aarch64-linux = "arm64"; }.${system};
  url = "https://download.pingcap.org/tidb-community-server-v${version}-linux-${arch}.tar.gz";

  hashes = {
    aarch64-linux = "sha256-ZtFqm4PllBRIGiRLzBynWvdcmegXD8WMPzknXwJYKBg=";
    x86_64-linux = "sha256-CovqGP4nciRWfB+mGQcCP+VBkVOmC6hzRXO2gvXylpc=";
  };

  full-archive = builtins.fetchTarball {
    url = url;
    sha256 = hashes.${system};
  };
in pkgs.stdenv.mkDerivation {
  __contentAddressed = true;

  inherit pname version;

  src = "${full-archive}/${name}-v${version}-linux-${arch}.tar.gz";

  nativeBuildInputs = [ pkgs.autoPatchelfHook ];
  # used by autopatchelf
  buildInputs = [ pkgs.glibc pkgs.libgcc ];

  dontUnpack = true;
  buildPhase = ''
    tar -xzf $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ${pname} $out/bin/${pname}
  '';
}

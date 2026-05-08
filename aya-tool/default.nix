{
  lib,
  symlinkJoin,
  aya-tool-unwrapped,
  bpftools,
  rust-bindgen,
  makeWrapper,
}:
symlinkJoin {
  name = "aya-tool-${aya-tool-unwrapped.version}";
  pname = "aya-tool";

  paths = [ aya-tool-unwrapped ];

  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram "$out/bin/aya-tool" \
      --suffix PATH : "${
        lib.makeBinPath [
          bpftools
          rust-bindgen
        ]
      }"
  '';

  inherit (aya-tool-unwrapped) meta version;
}

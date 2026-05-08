{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aya";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "aya-rs";
    repo = "aya";
    tag = "aya-v${finalAttrs.version}";
    hash = "sha256-rBqL4NIQB1u0Mh2cjxLkvDhyXB0lqxqSFy9Dy7yXCSo=";
    fetchSubmodules = true;
  };

  cargoLock.lockFile = ./Cargo.lock;
  postPatch = ''
    cp -L "${./Cargo.lock}" Cargo.lock
  '';

  buildAndTestSubdir = "aya-tool";
  doCheck = true;

  meta = {
    description = "Aya is an eBPF library for the Rust programming language, built with a focus on developer experience and operability";
    homepage = "https://github.com/aya-rs/aya";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "aya-tool";
  };
})

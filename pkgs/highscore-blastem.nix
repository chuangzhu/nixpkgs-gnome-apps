{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, libhighscore
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-blastem";
  version = "0-unstable-2024-11-16";

  src = fetchFromGitHub {
    owner = "alice-mkh";
    repo = "blastem-highscore";
    rev = "4e7962668a58bb0904d8a94b86082a297dba88fb";
    hash = "sha256-uhYfsofdBI2l+J3RT3JuTAmO+QwaKt1TXC4steO0KSo=";
  };

  sourceRoot = "source/highscore";

  postPatch = ''
    patchShebangs gen-db.sh
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libhighscore
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=maybe-uninitialized";

  passthru.updateScript = unstableGitUpdater { url = finalAttrs.src.gitRepoUrl; };

  meta = {
    description = "Port of BlastEm to Highscore";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ chuangzhu ];
  };
})

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
  pname = "highscore-stella";
  version = "0-unstable-2024-11-18";

  src = fetchFromGitHub {
    owner = "alice-mkh";
    repo = "stella";
    rev = "7b6c5a5118421a03f2795a03d0b45573a29a7fdb";
    hash = "sha256-yDff+YNE7aqaUOmm02UDxhjbiMowj1yaKZaTgqHFGaY=";
  };

  sourceRoot = "source/src/os/highscore";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libhighscore
  ];

  passthru.updateScript = unstableGitUpdater { url = finalAttrs.src.gitRepoUrl; };

  meta = {
    description = "Port of Stella to Highscore";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ chuangzhu ];
  };
})

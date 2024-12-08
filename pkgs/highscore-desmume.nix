{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, libhighscore
, SDL2
, libpcap
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-desmume";
  version = "0-unstable-2024-11-16";

  src = fetchFromGitHub {
    owner = "alice-mkh";
    repo = "desmume";
    rev = "ca76b4a57e8a0e8883953f47d5a2f7a46179c200";
    hash = "sha256-YeIipoUdpXd0RJVm0VGNkio4qNuj56esoJ5yK9ft0Xc=";
  };

  sourceRoot = "source/desmume/src/frontend/highscore";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libhighscore
    SDL2
    libpcap
  ];

  # cc1plus: error: '-Wformat-security' ignored without '-Wformat' [-Werror=format-security]
  hardeningDisable = [ "format" ];

  passthru.updateScript = unstableGitUpdater { url = finalAttrs.src.gitRepoUrl; };

  meta = {
    description = "Port of DeSmuME to Highscore";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ chuangzhu ];
  };
})

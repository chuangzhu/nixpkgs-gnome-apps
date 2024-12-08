{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, libhighscore
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-bsnes";
  version = "0-unstable-2024-11-16";

  src = fetchFromGitHub {
    owner = "alice-mkh";
    repo = "bsnes";
    rev = "909811149ce04b2b9d21488507fdc0633e183194";
    hash = "sha256-U2OgD8d2IUB26vmkSbtocAURpTwtSU3vSrylX4V5eRk=";
  };

  sourceRoot = "source/bsnes";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libhighscore
  ];

  makeFlags = [
    "target=highscore"
    "binary=library"
    "build=performance"
    "local=false"
    "platform=linux"
  ];

  installFlags = [
    "libdir=${placeholder "out"}/lib"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = unstableGitUpdater { url = finalAttrs.src.gitRepoUrl; };

  meta = {
    description = "Port of bsnes to Highscore";
    inherit (finalAttrs.src.meta) homepage;
    license = with lib.licenses; [ gpl2Plus mit ];
    maintainers = with lib.maintainers; [ chuangzhu ];
    platforms = lib.platforms.linux;
  };
})

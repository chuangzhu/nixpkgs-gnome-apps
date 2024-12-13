{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libhighscore
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-mgba";
  version = "0-unstable-2024-11-16";

  src = fetchFromGitHub {
    owner = "alice-mkh";
    repo = "mgba";
    rev = "0c719d3ca21b10fc7228231f9ce796c4d7df6a6b";
    hash = "sha256-60v/h1uSWg4uMGL4gbUbaH5EhiymsbsnVcgda/HFRN0=";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libhighscore
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_DEBUGGERS" false)
    (lib.cmakeBool "USE_EDITLINE" false)
    (lib.cmakeBool "ENABLE_GDB_STUB" false)
    (lib.cmakeBool "USE_ZLIB" false)
    (lib.cmakeBool "USE_MINIZIP" false)
    (lib.cmakeBool "USE_PNG" false)
    (lib.cmakeBool "USE_LIBZIP" false)
    (lib.cmakeBool "USE_SQLITE3" false)
    (lib.cmakeBool "USE_ELF" false)
    (lib.cmakeBool "USE_LUA" false)
    (lib.cmakeBool "USE_JSON_C" false)
    (lib.cmakeBool "USE_LZMA" false)
    (lib.cmakeBool "USE_DISCORD_RPC" false)
    (lib.cmakeBool "ENABLE_SCRIPTING" false)
    (lib.cmakeBool "BUILD_QT" false)
    (lib.cmakeBool "BUILD_SDL" false)
    (lib.cmakeBool "BUILD_HIGHSCORE" true)
    (lib.cmakeBool "SKIP_LIBRARY" true)
  ];

  passthru.updateScript = unstableGitUpdater { url = finalAttrs.src.gitRepoUrl; hardcodeZeroVersion = true; };

  meta = {
    description = "Port of mGBA to Highscore";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ chuangzhu ];
  };
})

{ stdenv, lib, fetchFromGitHub, cmake, git, python312Packages, eigen, python312
, ... }:
stdenv.mkDerivation rec {
  pname = "prjxray";
  version = "bdbc665852b82f589ff775a8f6498542dbec0a07";

  src = fetchFromGitHub {
    owner = "openXC7";
    repo = "prjxray";
    rev = "132342f7a27c650a7cbedda663e2f33bc4a582f5";
    fetchSubmodules = true;
    hash = "sha256-b/UQAu4hvAJ5Jng6z1XmlVpRUN1mb1igefcy9/c2HbM=";
  };

  nativeBuildInputs = [ cmake git ];
  buildInputs = [ python312Packages.boost python312 eigen ];

  patchPhase = ''
    sed -i 's/cmake /cmake -Wno-deprecated /g' Makefile
    sed -i '29 itarget_compile_options(libprjxray PUBLIC "-Wno-deprecated")' lib/CMakeLists.txt
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -v tools/xc7frames2bit tools/bitread tools/xc7patch $out/bin
    cp -v $srcs/utils/fasm2frames.py $out/bin/fasm2frames
    chmod 755 $out/bin/fasm2frames
    cp -v $srcs/utils/bit2fasm.py $out/bin/bit2fasm
    chmod 755 $out/bin/bit2fasm
    mkdir -p $out/usr/share/python3/
    cp -rv $srcs/prjxray $out/usr/share/python3/
  '';

  doCheck = false;

  meta = with lib; {
    description = "Xilinx series 7 FPGA bitstream documentation";
    homepage = "https://github.com/f4pga/prjxray";
    license = licenses.isc;
    platforms = platforms.all;
  };
}

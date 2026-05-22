{
    #-- Importar paquetes de nix
    pkgs ? import <nixpkgs> { }, 
}:

let
  fasm-pkg = pkgs.python3Packages.callPackage ./fasm.nix {};
  prjxray = pkgs.callPackage ./prjxray.nix {
    cmake = pkgs.cmake;
    git = pkgs.git;
    eigen = pkgs.eigen;
    python312 = pkgs.python312;
#     # Pasamos python312Packages explícitamente para asegurar la compatibilidad con tu archivo
    python312Packages = pkgs.python312Packages;
   };
in
# mkShell is a helper function                                              
pkgs.mkShell {                                                              
    name = "fpga-dev-environment";
    buildInputs = [                                                           
        # -- Lista de paquetes en el entorno
        pkgs.cmake
        pkgs.python312Packages.pyyaml
        pkgs.pypy3                                               
        pkgs.yosys
        pkgs.nextpnr-xilinx 
        fasm-pkg
        prjxray
        
    ];                                                                        
    shellHook = ''                                                                                              
    echo "FPGA Artix7 Xilinx. Placa Basys3" 
    '';                                                                       
}

# { lib
# , pythonOlder
# , jre_headless
# , antlr4_9
# , textx
# , cython
# , fetchpatch
# }:
# prjxray-pkg = pkgs.callPackage ./prjxray.nix {
#     cmake = pkgs.cmake;
#     git = pkgs.git;
#     eigen = pkgs.eigen;
#     python312 = pkgs.python312;
#     # Pasamos python312Packages explícitamente para asegurar la compatibilidad con tu archivo
#     python312Packages = pkgs.python312Packages;
#   };
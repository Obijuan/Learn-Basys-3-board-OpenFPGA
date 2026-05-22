{
    #-- Importar paquetes de nix
    pkgs ? import <nixpkgs> { }, 
}:

let
  fasm-pkg = pkgs.python3Packages.callPackage ./fasm.nix {};

in
# mkShell is a helper function                                              
pkgs.mkShell {                                                              
    name = "fpga-dev-environment";
    buildInputs = [                                                           
        # -- Lista de paquetes en el entorno
        pkgs.pypy3                                               
        pkgs.yosys
        pkgs.nextpnr-xilinx 
        fasm-pkg                                                            
    ];                                                                        
    shellHook = ''                                                                                              
    echo "FPGA Artix7 Xilinx. Placa Basys3" 
    '';                                                                       
}


{
    #-- Importar paquetes de nix
    pkgs ? import <nixpkgs> { }, 
}:

# mkShell is a helper function                                              
pkgs.mkShell {                                                              
    name = "fpga-dev-environment";
    buildInputs = [                                                           
        # -- Lista de paquetes en el entorno
        pkgs.pypy3                                               
        pkgs.yosys
        pkgs.nextpnr-xilinx                                                             
    ];                                                                        
    shellHook = ''                                                                                              
    echo "FPGA Artix7 Xilinx. Placa Basys3" 
    '';                                                                       
}


# Learn-Basys-3-board-OpenFPGA
Learning about the Basys-3 FPGA board using Opensource tools
More information on the [wiki](https://github.com/Obijuan/Learn-Basys-3-board-OpenFPGA/wiki)  (In Spanish)

# Puesta en marcha

1. Instalar el entorno  [Nix](https://nixos.org/)

```bash
curl -L https://nixos.org/nix/install | sh
```

2. Abrir una shell de nix, desde el directorio principal del proyecto `nix-shell`

La primera vez se instalaran todos los paquetes necesario y tardará un rato. Las siguientes veces irá muy rápido

```bash
obijuan@JANEL:~/Develop/Learn-Basys-3-board-OpenFPGA$ nix-shell 
FPGA Artix7 Xilinx. Placa Basys3

[nix-shell:~/Develop/Learn-Basys-3-board-OpenFPGA]$ 
```

3. La primera vez hay que **generar la base de datos** de la FPGA. Ejecuta el script `generate-db.sh`

```bash
[nix-shell:~/Develop/Learn-Basys-3-board-OpenFPGA]$ ./generate-db.sh 
➡️  Generando fichero ./chipdb/xc7a35tcpg236.bin
pypy3 /nix/store/j6pri4nf2z3s8p3fdf4fa1ydz9wfmyym-nextpnr-xilinx-0.8.2-unstable-2026-03-13/share/nextpnr/python/bbaexport.py --device xc7a35tcpg236-1 --bba ./chipdb/xc7a35tcpg236.bba
Exporting tile and site type data...
Exporting nodes...
Exporting tile and site instances...
bbasm -l ./chipdb/xc7a35tcpg236.bba ./chipdb/xc7a35tcpg236.bin

[nix-shell:~/Develop/Learn-Basys-3-board-OpenFPGA]$
```

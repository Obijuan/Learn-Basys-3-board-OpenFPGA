#!/usr/bin/env bash

echo "Comienza el script..."

#-- Fase 1: Sintesis
#-- yosys está en las oss-cad-suite, pero lo voy a incluir tambien en
#-- el "pack" de momento
YOSYS_EXEC=`which yosys`

echo "Ejecutable 1:"$YOSYS_EXEC
echo "Dependencias:"
ldd $YOSYS_EXEC

#-- Ejecutables
#-- yosys
#-- nextpnr-xilinx
#-- fasm2frames (python!)
#-- xc7frames2bit

#-- Algoritmo
#0. Examinar archivo binario
#1. Recorrer todas las dependencias en un bucle
#2. Leer dependencia: Nombre biblioteca, Path
#3. Si la dependencia es linux-vdso, pasar a la siguiente
#4. copiar la biblioteca al directorio lib, si no existe ya
#5. repetir



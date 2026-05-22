#!/usr/bin/env bash

#-- Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[36m'
RESET='\033[0m'  #-- Color por defecto

#-- Directorio donde esta instalado la herramienta nextpnr-xilinx
NEXTPNR_DIR=$(dirname $(dirname $(which nextpnr-xilinx)))

#-- Directorio donde esta la herramienta bbaexport.py
BBAEXPORT_DIR=$NEXTPNR_DIR/share/nextpnr/python

#-- Directorio donde poner la base de datos de la FPGA
CHIPDB=./chipdb

#-- Crear el directorio chipdb por si no estuviese creado
mkdir -p $CHIPDB

#---- Generar la base de datos para ARTIX
PART="xc7a35tcpg236"
CMD1="\
pypy3 $BBAEXPORT_DIR/bbaexport.py \
  --device $PART-1 
  --bba $CHIPDB/$PART.bba\
"
CMD2="bbasm -l $CHIPDB/$PART.bba $CHIPDB/$PART.bin"

echo -e $BLUE"➡️  Generando fichero $CHIPDB/$PART.bin"$RESET
echo -e $CYAN$CMD1$RESET
$CMD1

if [ $? -ne 0 ]; then
    echo -e $RED"> Abortando...\n"$RESET
    exit 1
fi

echo -e $CYAN$CMD2$RESET
$CMD2

if [ $? -ne 0 ]; then
    echo -e $RED"> Abortando...\n"$RESET
    exit 1
fi

#-- Limpiar: este fichero ya no es necesario
rm -rf $CHIPDB/$PART.bba






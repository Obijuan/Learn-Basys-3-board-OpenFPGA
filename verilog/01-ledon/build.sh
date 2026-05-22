#!/usr/bin/env bash

#-- Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RESET='\033[0m'  #-- Color por defecto

#-- Nombre de la entidad top a probar, sin extension
#-- Se lee directamente del nombre del directorio actual,
#-- eliminado el numero inicial
CURRENT_DIR=${PWD##*/}
TOP=${CURRENT_DIR:3}

#-- Fichero de restricciones
XDC=../../basys3.xdc

#-- Dependencias
DEPS=""

#-- Directorio de la base de datos
CHIPDB=../../chipdb

#-- Descripcion de la FPGA usada
PART=xc7a35tcpg236
PART1=$PART"-1"


#-- Indicar el nombre del ejemplo actual (sin extension)
echo -e "\n$YELLOW─────────────────────────────────"
echo -e "🟡 $YELLOW$TOP$RESET"
echo -e "$YELLOW─────────────────────────────────"$RESET

#------------------------------
#-- SINTESIS
#------------------------------
echo -e $BLUE"➡️  Sintetizando..."$RESET
yosys -p "synth_xilinx  \
              -arch xc7 -top $TOP; write_json $TOP.json" \
              $TOP.v $DEPS -q

if [ $? -ne 0 ]; then
    echo -e $RED"> Abortando...\n"$RESET
    exit 1
fi


#--------------------------------------
#-- RUTADO
#--------------------------------------
echo -e $BLUE"➡️  Rutando..."$RESET
nextpnr-xilinx --chipdb $CHIPDB/$PART.bin \
       --xdc $XDC --json $TOP.json --fasm $TOP.fasm -q

if [ $? -ne 0 ]; then
    echo -e $RED"> Abortando...\n"$RESET
    exit 1
fi

#--------------------------------------------
#-- GENERACION DEL BITSTREAM
#--------------------------------------------

#-- Generacion del bitstream
echo -e $BLUE"➡️  Generando bitstream..."$RESET
openxc7.fasm2frames --part $PART1 \
  --db-root $PRJXRAY_DB_DIR \
  $NAME.fasm > $NAME.frames 2> /dev/null

if [ $? -ne 0 ]; then
    echo -e $RED"> Abortando...\n"$RESET
    exit 1
fi

#------------------------------
#-- Compresion del Bitstream
#------------------------------
echo -e $BLUE"➡️  Comprimiendo..."
openxc7.xc7frames2bit --part_file $PRJXRAY_DB_DIR/$PART1/part.yaml \
  --part_name $PART1 --frm_file $NAME.frames \
  --output_file $NAME.bit

if [ $? -ne 0 ]; then
    echo -e $RED"> Abortando...\n"$RESET
    exit 1
fi

echo -e "$GREEN─────────────────────────────────"
echo -e $GREEN"✅ OK!"$RESET
echo -e "$GREEN─────────────────────────────────\n"$RESET



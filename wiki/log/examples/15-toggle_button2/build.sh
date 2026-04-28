#!/usr/bin/env bash

#-- Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RESET='\033[0m'  #-- Color por defecto

#-- Obtener el nombre del directorio actual,
#-- ${PWD##*/} elimina todo hasta la última barra diagonal
CURRENT_DIR=${PWD##*/}

#-- Obtener el nombre del ejemplo, eliminando los 3
#-- primeros caracteres
#-- La sintaxis ${variable:posicion} empieza a contar desde 0
NAME=${CURRENT_DIR:3}

#-- Dependencias
DEPS="../lib/signals.v ../lib/buttons.v"

#-- Path del nextpnr-xilinx
NEXTPNR_XILINX_DIR="/snap/openxc7/current/opt/nextpnr-xilinx"

#-- Path a la base de datos
PRJXRAY_DB_DIR=${NEXTPNR_XILINX_DIR}"/external/prjxray-db/artix7"

#-- Descripcion de la FPGA usada
PART=xc7a35tcpg236
PART1=$PART"-1"

#-- Indicar el nombre del ejemplo actual (sin extension)
echo -e "\n$YELLOW─────────────────────────────────"
echo -e "🟡 $YELLOW$NAME$RESET"
echo -e "$YELLOW─────────────────────────────────"$RESET

#------------------------------
#-- SINTESIS
#------------------------------
echo -e $BLUE"➡️  Sintetizando..."$RESET
apio raw -- yosys -p "read_verilog -I../lib $NAME.v $DEPS; \
              synth_xilinx -arch xc7 -top $NAME; \
              write_json $NAME.json" \
              -q

if [ $? -ne 0 ]; then
    echo -e $RED"> Abortando...\n"$RESET
    exit 1
fi


#--------------------------------------
#-- RUTADO
#--------------------------------------
echo -e $BLUE"➡️  Rutando..."$RESET
openxc7.nextpnr-xilinx --chipdb ../chipdb/$PART.bin \
       --xdc basys3.xdc --json $NAME.json --fasm $NAME.fasm #-q

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



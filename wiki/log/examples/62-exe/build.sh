#!/usr/bin/env bash

#-- Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RESET='\033[0m'  #-- Color por defecto

NAME=top

#-- Directorio donde esta la librearia
LIB="../lib"

#-- Dependencias
DEPS="$LIB/wishbone_interface.sv \
      $LIB/wishbone_leds.sv \
      $LIB/synchronizer.sv \
      $LIB/wishbone_interconnect.sv \
      $LIB/wishbone_buttons.sv \
      $LIB/wishbone_switches.sv \
      $LIB/uart_tx.sv \
      $LIB/uart_rx.sv \
      $LIB/wishbone_uart.sv \
      $LIB/wishbone_ram.sv \
      $LIB/pipeline_status.sv \
      $LIB/constants.sv \
      $LIB/fetch_stage.sv \
      $LIB/forwarding.sv \
      $LIB/instruction.sv \
      $LIB/op.sv \
      $LIB/csr.sv \
      $LIB/decode_stage.sv \
      $LIB/register_file.sv \
      $LIB/instruction_decoder.sv \
      $LIB/execute_stage.sv \
      mcu.sv \
      $LIB/utils.sv \
      $LIB/disp7seg.sv \
      $LIB/timming.sv \
     "

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
apio raw -- yosys -m slang \
    -p "read -sv $LIB/memory.sv" \
    -p "read_slang --ignore-unknown-modules \
       -I../lib $DEPS top.sv" \
    -p "synth_xilinx -arch xc7 -top top; \
        write_json top.json" \
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
       --xdc basys3.xdc --json top.json --fasm top.fasm #-q

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
  top.fasm > top.frames 2> /dev/null

if [ $? -ne 0 ]; then
    echo -e $RED"> Abortando...\n"$RESET
    exit 1
fi

#------------------------------
#-- Compresion del Bitstream
#------------------------------
echo -e $BLUE"➡️  Comprimiendo..."
openxc7.xc7frames2bit --part_file $PRJXRAY_DB_DIR/$PART1/part.yaml \
  --part_name $PART1 --frm_file top.frames \
  --output_file top.bit

if [ $? -ne 0 ]; then
    echo -e $RED"> Abortando...\n"$RESET
    exit 1
fi

echo -e "$GREEN─────────────────────────────────"
echo -e $GREEN"✅ OK!"$RESET
echo -e "$GREEN─────────────────────────────────\n"$RESET



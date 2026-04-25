#!/usr/bin/env bash

#-- Path del nextpnr-xilinx
NEXTPNR_XILINX_DIR="/snap/openxc7/current/opt/nextpnr-xilinx"

#-- Path a la base de datos
PRJXRAY_DB_DIR=${NEXTPNR_XILINX_DIR}"/external/prjxray-db/artix7"

#-- Descripcion de la FPGA usada
PART=xc7a35tcpg236
PART1=$PART"-1"

#-- Realizar la sintesis
apio raw -- yosys -p "synth_xilinx -flatten -abc9  \
              -arch xc7 -top ledon; write_json ledon.json" \
              ledon.v  -q

openxc7.nextpnr-xilinx --chipdb ../chipdb/$PART.bin \
       --xdc ledon.xdc --json ledon.json --fasm ledon.fasm -q

openxc7.fasm2frames --part $PART1 \
  --db-root $PRJXRAY_DB_DIR ledon.fasm > ledon.frames

openxc7.xc7frames2bit --part_file $PRJXRAY_DB_DIR/$PART1/part.yaml \
  --part_name $PART1 --frm_file ledon.frames \
  --output_file ledon.bit


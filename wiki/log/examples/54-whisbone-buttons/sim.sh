#!/usr/bin/env bash


#-- Directorio donde esta la librearia
LIB="../lib"

#-- Dependencias
DEPS="wishbone_interface.sv \
      wishbone_leds.sv"

#-- Simulacion con verilator
verilator --binary  --trace-fst -sv --top-module TB -I$LIB \
  $DEPS top_tb.sv && \
  ./obj_dir/VTB

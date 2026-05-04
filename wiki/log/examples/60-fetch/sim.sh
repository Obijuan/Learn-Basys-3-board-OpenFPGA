#!/usr/bin/env bash


#-- Directorio donde esta la librearia
LIB="../lib"

#-- Dependencias
DEPS="wishbone_interface.sv \
      wishbone_leds.sv \
      synchronizer.sv \
      wishbone_interconnect.sv \
      wishbone_buttons.sv \
      wishbone_switches.sv \
      uart_tx.sv \
      uart_rx.sv \
      wishbone_uart.sv \
      memory.sv
      wishbone_ram.sv
      "

#-- Simulacion con verilator
verilator --binary  --trace-fst -sv --top-module TB -I$LIB \
  $DEPS top_tb.sv && \
  ./obj_dir/VTB


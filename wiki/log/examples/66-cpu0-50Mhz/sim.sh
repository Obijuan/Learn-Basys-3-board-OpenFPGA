#!/usr/bin/env bash


#-- Directorio donde esta la librearia
LIB="../lib"

#-- Directorio donde estan los diseños
SRC="./rtl"

#-- Dependencias
DEPS="wishbone_interface.sv \
      wishbone_leds.sv \
      synchronizer.sv \
      wishbone_interconnect.sv \
      wishbone_buttons.sv \
      wishbone_switches.sv \
      wishbone_timer.sv \
      wishbone_segments.sv \
      uart_tx.sv \
      uart_rx.sv \
      wishbone_uart.sv \
      memory.sv \
      wishbone_ram.sv \
      constants.sv \
      pipeline_status.sv \
      op.sv \
      csr.sv \
      forwarding.sv \
      instruction.sv \
      instruction_decoder.sv \
      fetch_stage.sv \
      decode_stage.sv \
      execute_stage.sv \
      memory_stage.sv \
      utils.sv \
      disp7seg.sv \
      timming.sv \
      $SRC/mcu.sv \
      "

#-- Simulacion con verilator
verilator --binary  --trace-fst --trace-structs -sv --top-module TB -I$LIB \
  $DEPS $SRC/top_tb.sv && \
  ./obj_dir/VTB


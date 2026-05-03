#!/usr/bin/env bash

#-- Simulacion con verilator
verilator --binary  --trace-fst -sv --top-module TB \
wishbone_interface.sv wishbone_leds_tb.sv wishbone_leds.sv && \
 ./obj_dir/VTB

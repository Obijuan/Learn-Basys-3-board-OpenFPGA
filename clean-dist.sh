#!/usr/bin/env bash

# -- Borrar las librerias
rm -f dist/lib/*

# -- Borrar los ejecutables
rm -f dist/libexec/*

# -- Borrar los "wrappers"
rm -f dist/bin/*

# -- Borrar informacion adicional
chmod +w dist/share/yosys/python3
sudo rm -rf dist/share/yosys/python3/*

chmod +w dist/share/yosys/xilinx
sudo rm -rf dist/share/yosys/xilinx/*

sudo rm -rf dist/share/yosys/*.v


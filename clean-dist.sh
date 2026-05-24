#!/usr/bin/env bash

# -- Borrar las librerias
rm -f dist/lib/*

# -- Borrar los ejecutables
rm -f dist/libexec/*

# -- Borrar los "wrappers"
rm -f dist/bin/*

# -- Borrar informacion adicional
chmod +w dist/share/yosys
sudo rm -rf dist/share/yosys


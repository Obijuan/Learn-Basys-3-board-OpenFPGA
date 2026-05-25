#!/usr/bin/env bash

# -- Borrar las librerias
sudo rm -rf dist/lib/*

# -- Borrar los ejecutables
rm -f dist/libexec/*

# -- Borrar los "wrappers"
rm -f dist/bin/*
rm -f dist/bin/.fasm*

# -- Borrar informacion adicional
#chmod +w dist/share/yosys
sudo rm -rf dist/share/yosys


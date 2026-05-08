#!/usr/bin/env bash

#-- Directorio de construccion
BUILD=_build

#-- Nombre del fichero a ensamblar, sin extension
NAME=$1
NAME="${NAME%.*}" #-- Quitar extension

cat $BUILD/$NAME.hex > /dev/ttyUSB1


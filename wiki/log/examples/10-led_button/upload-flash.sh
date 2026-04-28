#!/usr/bin/env bash

#-- Obtener el nombre del directorio actual,
CURRENT_DIR=${PWD##*/}

#-- Obtener el nombre del ejemplo, eliminando los 3
NAME=${CURRENT_DIR:3}

apio raw -- openFPGALoader --board basys3 --write-flash $NAME.bit


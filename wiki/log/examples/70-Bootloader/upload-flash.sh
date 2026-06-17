#!/usr/bin/env bash

#-- Directorio de construccion
BUILD=_build

NAME=$BUILD/top

openFPGALoader --board basys3 --write-flash $NAME.bit


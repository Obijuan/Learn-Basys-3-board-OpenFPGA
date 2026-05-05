#!/usr/bin/env bash

#-- Directorio de construccion
BUILD=_build

NAME=$BUILD/top


apio raw -- openFPGALoader --board basys3 --bitstream $NAME.bit


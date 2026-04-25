#!/usr/bin/env bash

NAME=button_posedge

apio raw -- openFPGALoader --board basys3 --bitstream $NAME.bit


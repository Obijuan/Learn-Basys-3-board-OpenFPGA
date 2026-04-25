#!/usr/bin/env bash

NAME=led8_value

apio raw -- openFPGALoader --board basys3 --bitstream $NAME.bit


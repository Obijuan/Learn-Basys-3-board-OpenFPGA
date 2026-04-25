#!/usr/bin/env bash

NAME=leds16

apio raw -- openFPGALoader --board basys3 --bitstream $NAME.bit


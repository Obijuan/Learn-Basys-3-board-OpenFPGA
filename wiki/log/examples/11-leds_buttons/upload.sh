#!/usr/bin/env bash

NAME=leds_buttons

apio raw -- openFPGALoader --board basys3 --bitstream $NAME.bit


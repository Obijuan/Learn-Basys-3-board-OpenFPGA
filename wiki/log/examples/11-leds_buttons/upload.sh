#!/usr/bin/env bash

NAME=led_button

apio raw -- openFPGALoader --board basys3 --bitstream $NAME.bit


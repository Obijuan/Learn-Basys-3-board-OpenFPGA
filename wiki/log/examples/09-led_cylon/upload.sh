#!/usr/bin/env bash

NAME=led_cylon

apio raw -- openFPGALoader --board basys3 --bitstream $NAME.bit


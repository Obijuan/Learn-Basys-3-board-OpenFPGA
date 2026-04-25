#!/usr/bin/env bash

NAME=toggle_led

apio raw -- openFPGALoader --board basys3 --bitstream $NAME.bit


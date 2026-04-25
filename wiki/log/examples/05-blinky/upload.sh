#!/usr/bin/env bash

NAME=blinky

apio raw -- openFPGALoader --board basys3 --bitstream $NAME.bit


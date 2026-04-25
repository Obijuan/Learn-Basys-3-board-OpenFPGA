#!/usr/bin/env bash

NAME=led_seq1

apio raw -- openFPGALoader --board basys3 --bitstream $NAME.bit


#!/usr/bin/env bash

NAME=switch_led

apio raw -- openFPGALoader --board basys3 --bitstream $NAME.bit


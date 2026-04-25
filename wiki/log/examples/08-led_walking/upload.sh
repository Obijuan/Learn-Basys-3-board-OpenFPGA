#!/usr/bin/env bash

NAME=led_walking

apio raw -- openFPGALoader --board basys3 --bitstream $NAME.bit


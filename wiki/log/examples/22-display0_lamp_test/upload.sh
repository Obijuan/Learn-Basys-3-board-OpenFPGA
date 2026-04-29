#!/usr/bin/env bash

NAME=display0_lamp_test

apio raw -- openFPGALoader --board basys3 --bitstream $NAME.bit


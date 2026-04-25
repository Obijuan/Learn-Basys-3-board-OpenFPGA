#!/usr/bin/env bash

NAME=toggle_button

apio raw -- openFPGALoader --board basys3 --bitstream $NAME.bit


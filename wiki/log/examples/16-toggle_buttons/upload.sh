#!/usr/bin/env bash

NAME=toggle_buttons

apio raw -- openFPGALoader --board basys3 --bitstream $NAME.bit


#!/usr/bin/env bash

NAME=toggle_buttons_gen

apio raw -- openFPGALoader --board basys3 --bitstream $NAME.bit


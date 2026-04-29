#!/usr/bin/env bash

NAME=led_seq1

apio raw -- openFPGALoader --board basys3 --write-flash $NAME.bit


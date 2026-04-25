#!/usr/bin/env bash

NAME=ledon2

apio raw -- openFPGALoader --board basys3 --write-flash $NAME.bit


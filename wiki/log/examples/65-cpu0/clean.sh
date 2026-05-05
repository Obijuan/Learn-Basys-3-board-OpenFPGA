#!/usr/bin/env bash

rm -rf _build
rm -rf obj_dir

rm -f *.bit *.fasm *.frames *.json *.fst *.elf
rm -rf obj_dir
rm -f *.dis
rm -f *.bin
mv init.mem init.back
rm -f *.mem
mv init.back init.mem




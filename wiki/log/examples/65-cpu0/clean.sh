#!/usr/bin/env bash


rm -f *.bit *.fasm *.frames *.json *.fst
rm -rf obj_dir
rm *.dis
rm *.bin
mv init.mem init.back
rm *.mem
mv init.back init.mem




#!/bin/bash
rm out
rm out2
make > out
grep 'scr pos' out | head -n 49152 > out2
./disp2.py

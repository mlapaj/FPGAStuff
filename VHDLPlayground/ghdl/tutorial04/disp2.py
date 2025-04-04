#!/bin/python3
import numpy as np
from PIL import Image
fileName = 'source/image.scr'
with open('out2') as f:
    lines = f.readlines()
pixels = []
cur_bit = 0
val = 0;
for line in lines:
    if (int(line.strip().split()[-1][1]) == 1):
        val = val | 1 << cur_bit
    if (cur_bit == 7):
        pixels.append(val)
        cur_bit = 0;
        val = 0;
    else:
        cur_bit = cur_bit + 1;

width=256
height=192
data = np.arange(width * height, dtype=np.int64).reshape((height, width))
img_data = np.empty((height, width, 3), dtype=np.uint8)
for y in range (192):
    for x in range(256):
        col = 0;
        # we are extracting "linear data from testbench.... so as it is printed
        # to the screen, original, memory represenation is different ... but this is
        # not memory representation but SCREEN representation
        data = pixels[y*32+ x // 8]
        if (data & (1 << ((7-x) & 0b111))):
            col = 255
        img_data[y, x, 0] = col
        img_data[y, x, 1] = col
        img_data[y, x, 2] = col
Image.fromarray(img_data).show()

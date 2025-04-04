#!/bin/python3
import numpy as np
from PIL import Image

width=256
height=192


fileName = 'out3'
with open(fileName) as f:
    lines = f.readlines()
pixels = np.empty(width*height)
cur_bit = 0
val = 0;
for line in lines:
    t = line.strip()
    x=int(t[t.find("x=")+2:t.find(',')])
    y=int(t[t.find("y=")+2:t.find(']')])
    c=int(t[t.find("]='")+3:-1])
    #print(x,y,c)
    pixels[x+256*y]=c

data = np.arange(width * height, dtype=np.int64).reshape((height, width))
img_data = np.empty((height, width, 3), dtype=np.uint8)
for y in range (192):
    for x in range(256):
        col = 0;
        # we are extracting "linear data from testbench.... so as it is printed
        # to the screen, original, memory represenation is different ... but this is
        # not memory representation but SCREEN representation
        if (pixels[x+256*y]):
            col = 255
        img_data[y, x, 0] = col
        img_data[y, x, 1] = col
        img_data[y, x, 2] = col
Image.fromarray(img_data).show()

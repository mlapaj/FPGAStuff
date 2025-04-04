#!/bin/python3
import numpy as np
from PIL import Image
fileName = 'source/image.scr'
with open(fileName, mode='rb') as file: # b is important -> binary
    fileContent = file.read()

width=256
height=192
data = np.arange(width * height, dtype=np.int64).reshape((height, width))
img_data = np.empty((height, width, 3), dtype=np.uint8)
for y in range (192):
    for x in range(256):
        col = 0;
        new_y = ((y & 0b111) << 3) | ((y >> 3) & 0b111) | (y & 0b11000000)
        print("y is {} new_y {}".format(y,new_y))
        pos = (new_y << 5) + (x >> 3);

        print('fetching data from {} {} {} data {}'.format((new_y << 5),x >> 3,x & 0b111,pos))
        data = fileContent[pos]
        if (data & (1 << ((7-x) & 0b111))):
            col = 255
        img_data[y, x, 0] = col
        img_data[y, x, 1] = col
        img_data[y, x, 2] = col
Image.fromarray(img_data).show()

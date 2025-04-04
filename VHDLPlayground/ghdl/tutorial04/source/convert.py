#!/bin/python3
f = open("image.scr", mode="rb")
fileContent = f.read();
for b in fileContent:
    print('x"' + "{:02x}".format(b)  + '",')

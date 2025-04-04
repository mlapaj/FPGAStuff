#!/bin/python3 
f = open("48k.rom", mode="rb")
fileContent = f.read();
for b in fileContent:
    print('x"' + "{:02x}".format(b)  + '",')

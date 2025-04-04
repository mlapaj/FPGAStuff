#!/usr/bin/python3

print("Hello world")
inFileName = "out_ram_bytes.txt"
outFileName = "out_ram_bytes_reversed.txt"
with open(inFileName, mode='rb') as inFile:
    fileContent = inFile.read()
with open(outFileName, mode='wb') as outFile:
    for x in fileContent[::-1]:
        outFile.write(x.to_bytes(1,'big'))

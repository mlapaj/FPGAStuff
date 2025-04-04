#!/usr/bin/python3

print("Hello world")
inFileName = "o2"
outFileName = "o3"
with open(inFileName, mode='rb') as inFile:
    fileContent = inFile.read()
with open(outFileName, mode='wb') as outFile:
    for x in fileContent[::-1]:
        outFile.write(x.to_bytes(1,'big'))

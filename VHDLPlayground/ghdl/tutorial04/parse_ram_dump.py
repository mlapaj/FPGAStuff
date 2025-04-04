#!/usr/bin/python3

print("Hello world")
inFileName = "o"
outFileName = "o2"
with open(inFileName, mode='rb') as inFile:
    fileContent = inFile.read()
with open(outFileName, mode='wb') as outFile:
    bitPos = 0;
    val = 0;
    byte = 0;
    for x in fileContent[29:]:
        if (x == 0x3):
            val = val | 1 << (7-bitPos);
        if (bitPos == 7):
            byte = byte + 1;
            outFile.write(val.to_bytes(1,'big'));
            val = 0;
            bitPos = 0;
        else:
            bitPos=bitPos+1
    print("Byte {}".format(byte))

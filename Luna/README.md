# Intro 
Luna original repo: [https://github.com/greatscottgadgets/luna](https://github.com/greatscottgadgets/luna) - an Aramanth HDL library for USB.  
Aramanth: [https://github.com/amaranth-lang](https://github.com/amaranth-lang) - Python framework for producing FPGA code.  
This directory contains changes/adaptations for Tang Primer 20k board. (More info [https://wiki.sipeed.com/hardware/en/tang/tang-primer-20k/primer-20k.html](https://wiki.sipeed.com/hardware/en/tang/tang-primer-20k/primer-20k.html))

# My story
Early 2025 I have decided to learn something more about USB and also I wanted to learn Verilog (previously I did couple of small hobby-projects using VHDL language). I started with some existing IP cores implementations done in Verilog. They have required do to some adaptation. Unfortunately, some of them were not synthetisable and some of them were not working. After spending 2 weeks on investigation I have dropped this idea. While earlier investigation at the beginning of my USB journey I have found Luna, however, Luna was not using Verilog so I decided to not go in this direction. Ultimately, I did not had any other choice, I started to learn Aramanth firstly (did blinky example) and I started with Luna.
Because of this please:
- do not expect from me that I'll solve all issues,
- pay attention that this is simple, working example,

Finally, I have learned Verilog enough to work with code and I have learned Aramanth HDL basic concepts.
Next step for me is to investigate Aramanth and Luna possibilities.

# Details
My changes contains:
- Tang Primer 20k has 3317 USB phy which is compatible with one originally used in Luna. While studying Sipeed USB examples ([https://github.com/sipeed/TangPrimer-20K-example/tree/main/USB](https://github.com/sipeed/TangPrimer-20K-example/tree/main/USB)) I have discovered that ulpi clock is inverted. That was the main problem why it was not working for me. Because of this, I had to add invert clock change for Aramanth/Luna board definition files. 
- USB and Sync domain is using 60 MHz clock taken from 3317 phy.
- Created fork repo for Aramanth Boards. Added Board definition for Tang Primer 20k for Aramanth. Added possibility to invert Clock for PHY
- Created fork repo for Luna Boards. Added Board definition for Luna Library
- Reverted issue [https://github.com/greatscottgadgets/luna/issues/280](https://github.com/greatscottgadgets/luna/issues/280) in Luna - this is done locally in Docker script.
- Used Gowin EDA toolchain for building FPGA bitstream.


# How to
I have used docker approach since there are some wired dependencies between Luna/Luna Boards/Aramanth/AramanthBoards, Yosys and oter stuff.
All examples: `blinky, simple_device, acm_serial` are taken from original Luna repo
1. Clone repo
2. Place GOWIN EDA (download from [https://www.gowinsemi.com/en/support/home/](https://www.gowinsemi.com/en/support/home/)) in current directory, create directory `gowin`
3. Install docker
4. run script `./start_docker build`. It will automatically fetch all required files.
5. To get bash prompt, run `./start_docker`
6. Go to `/data/blinky` directory and start with blinky example. Check if leds are blinking. Use **S4** button on boards to reset
7. Go to `/data/simple_device` directory and run script. Attach cable (Note: you may need to use **S4** button to perform reset, sometimes USB device is not working after programming FPGA).
   Check dmesg, you should get something similar:
```[ 9434.599213] usb 1-4.3: new high-speed USB device number 12 using xhci_hcd
[ 9434.699252] usb 1-4.3: config 1 interface 0 altsetting 0 bulk endpoint 0x1 has invalid maxpacket 64
[ 9434.699256] usb 1-4.3: config 1 interface 0 altsetting 0 bulk endpoint 0x81 has invalid maxpacket 64
[ 9434.699456] usb 1-4.3: New USB device found, idVendor=1209, idProduct=0001, bcdDevice= 0.00
[ 9434.699459] usb 1-4.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 9434.699461] usb 1-4.3: Product: Test Device
[ 9434.699463] usb 1-4.3: Manufacturer: LUNA
[ 9434.699464] usb 1-4.3: SerialNumber: 1234
```
8. Go to `/data/acm_serial` and build example. (Note: you may need to use **S4** button to perform reset, sometimes USB device is not working after programming FPGA).
```
[11519.904185] usb 1-4.3: New USB device found, idVendor=16d0, idProduct=0f3b, bcdDevice= 0.00
[11519.904187] usb 1-4.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[11519.904189] usb 1-4.3: Product: USB-to-serial
[11519.904190] usb 1-4.3: Manufacturer: LUNA
[11519.938300] cdc_acm 1-4.3:1.0: ttyACM0: USB ACM device
[11519.938418] usbcore: registered new interface driver cdc_acm
[11519.938420] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
```
9. Open `sudo screen /dev/ttyACM0` and type some letters. You should get letters back in console.
10. Go to `data/counter_device` and run example. (Note: you may need to use **S4** button to perform reset, sometimes USB device is not working after programming FPGA). You should get:
```
[11727.277993] usb 1-4.3: New USB device found, idVendor=1209, idProduct=0001, bcdDevice= 0.00
[11727.277997] usb 1-4.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[11727.277999] usb 1-4.3: Product: Counter/Throughput Test
[11727.278001] usb 1-4.3: Manufacturer: LUNA
[11727.278002] usb 1-4.3: SerialNumber: no serial
```
11. Run `./app` in `/data/counter_device`. You should get:
```
Received 512 bytes: array('B', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255])
....
```
# Bugs
- Newer version of Luna 0.2.0 requires aramanth 0.5.0. This implementation is buggy. There are invalid entries in timing constraints file when Gowin Toolchain is used. I'll try to report this issue (or even I'd like to fix it).
- There are some dependency issues in aramanth boards and luna boards repos. I have fixed them on my local forks.
# Related
- [https://github.com/greatscottgadgets/luna/issues/281](https://github.com/greatscottgadgets/luna/issues/281) - Starting point for me.
- [https://github.com/sipeed/TangPrimer-20K-example/tree/main/USB](https://github.com/sipeed/TangPrimer-20K-example/tree/main/USB) - Sipeed example, looks like it was generated by Luna. There is a encrypted part here (fifo.usb_fifo)

# Thanks
At the end, I want to Thank Michael Ossman for his great contribution for USB devices area and also for giving us Software Defined Radio HackRF board. 

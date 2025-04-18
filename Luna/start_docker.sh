#!/bin/bash
if [ ! -d gowin ]; then
    echo "Please provide gowin IDE in IDE directory"
    exit -1;
fi
if [ "$1" == "build" ]; then
    echo "building image"
    sudo docker build -t luna-ml .
else
    echo "starting docker disposable container"
    echo "if you want to build image type: $0 build"
    sudo docker run --rm -it\
        --volume="$PWD/gowin:/gowin"\
        --volume="$PWD/data:/data"\
        --privileged\
        -v /dev/bus/usb:/dev/bus/usb\
        luna-ml
fi


#!/bin/bash

# Run script with ./start.sh to start the API.

sudo docker run -it --rm --privileged multiarch/qemu-user-static --credential yes --persistent yes
sudo docker run -p 4001:4000 -it mikaak/alpha-vantage:latest
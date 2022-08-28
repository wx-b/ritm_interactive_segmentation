#!/usr/bin/env bash

DOCKER_IMAGE=ritm_interactive_segmentation:fork-1-main

xhost +local:docker
docker run \
    -it --rm \
    --network=host \
    --gpus all \
    -v "$PWD":/work/ \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY $DOCKER_IMAGE \
    python3 demo.py --checkpoint resnet34_dh128_sbd --gpu

docker run \
    -it --rm \
    --network=host \
    --gpus all \
    -v "$PWD":/work/ \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY $DOCKER_IMAGE \
    bash

xhost +local:docker
docker run \
    -it --rm \
    --network=host \
    --gpus all \
    -v "$PWD":/work/ \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY $DOCKER_IMAGE \
    python3 server.py
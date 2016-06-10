Cloud9 v3 Dockerfile
=============


# Base Docker Image
Uses ubuntu as base image

# Inspiration from 
[kdelfour/supervisor-docker](https://registry.hub.docker.com/u/kdelfour/supervisor-docker/)

# Installation

## Install from git
docker build -t="renegulager/cloud9-docker" github.com/renegulager/cloud9-docker

## Usage  (binds to port 9999)

 (sudo?)   docker run -it -d -p 9999:80 -v /your-path/workspace/:/workspace/ renegulager/cloud9-docker



##TODO
The buildin webserver don't work 
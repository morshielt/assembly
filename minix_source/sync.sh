#!/bin/bash

cd "$(dirname "$0")" # set current working directory to the directory of the script

rsync -uav --exclude=".git" ./usr/include/ so:/usr/include/
rsync -uav --exclude=".git" ./usr/src/ so:/usr/src/

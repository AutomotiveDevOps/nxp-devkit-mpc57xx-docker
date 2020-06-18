#!/usr/bin/env bash

# Viele Wege führen nach Rom.
# 八仙過海，各施各法

# 1. Put PROJ_NAME in the docker file and parse it out.
# export PROJ_NAME=`grep "^ENV PROJ_NAME" Dockerfile | cut -f3 -d" " | tr '[:upper:]' '[:lower:]'`

# 2. Use the folder name/repository as the project name
export PROJ_NAME=$(echo $(basename $(dirname $(realpath ${0}))) | tr '[:upper:]' '[:lower:]')

# Build everything.
docker build .  --no-cache --rm --build-arg PROJ_NAME --file Dockerfile --tag ${PROJ_NAME}:latest

# Make a directory for the build artifacts, mount it in the docker image and copy out the build artifacts.
mkdir -p ${PWD}/artifacts
docker run --rm -v ${PWD}:/artifacts ${PROJ_NAME}:latest \
	cp -r /S32DS/artifacts/ /artifacts/

# Extract artifacts into artifacts. For the TUV, NTSB, FAA, et al you should probably archive the whole docker image.
cd artifacts/ && tar -xjf *.tar.bz2 --strip-components=1

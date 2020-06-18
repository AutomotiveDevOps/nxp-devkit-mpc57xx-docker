#!/usr/bin/env bash

# Get the current root directory.
export ROOT=$(dirname $(realpath ${0}))

# For each of the found build scripts.
for BUILD in `ls */build-5744p.sh`
do
# Change to the root directory
cd ${ROOT}
# Get the build script path and directory.
BUILD_SCRIPT=$(realpath ${BUILD})
BUILD_DIR=$(dirname ${BUILD})
# Change to the example directory
cd ${BUILD_DIR}
sh ${BUILD_SCRIPT}
done

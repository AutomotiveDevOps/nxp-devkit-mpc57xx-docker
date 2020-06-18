#!/usr/bin/env python3
"""
Copy build-5744p.sh and Dockerfile to each of the example directories.
"""

import shutil
import os

# What are we copying:
src_files = ["build-5744p.sh", "Dockerfile"]

# Where should we copy it.
import os
d = 'MPC5744P'
dest_dirs = [os.path.join(d, o) for o in os.listdir(d) if os.path.isdir(os.path.join(d,o))]
# For each destination:
for dest_dir in dest_dirs:
    # For each source file.
    for src_file in src_files:
        shutil.copyfile( # Copy the file
            src_file, # From the source
            os.path.join( # To a path defined
                dest_dir, # by the destination directory
                src_file # and the source file name.
            )
        )
# Copy the golden master Makefile to each directory.
for dest_dir in dest_dirs:
    shutil.copyfile( # Copy the file
        "makefiles/devkit_5744p.mk", # From the source
        os.path.join( # To a path defined
            dest_dir, # by the destination directory
            "Makefile" # and the source file name.
        )
    )

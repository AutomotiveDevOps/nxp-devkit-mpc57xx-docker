FROM s32ds-power-v1-2:latest
## Configuration
ARG PROJ_NAME
ENV PROJ_NAME=${PROJ_NAME}

# Set up the build directory
RUN mkdir -p /S32DS/build
WORKDIR /S32DS/build
# Copy Source, Include, & Project_Settings to the build source directory.
COPY Makefile /S32DS/build/Makefile
COPY src /S32DS/build/src
COPY include /S32DS/build/include
COPY Project_Settings /S32DS/build/Project_Settings
# Build everything.
RUN make \
	--always-make \
	--directory=/S32DS/build \
	--environment-overrides \
	--makefile=/S32DS/build/Makefile \
	--jobs=8

# Generate Digital Forensics XML: Maximum tracibility for all of the build and artifacts.
#     DFXML is a file format designed to capture metadata and provenance 
#     information about the operation of software tools in a systematic fashion.
RUN hashdeep -c md5,sha256,tiger,whirlpool -d -r /S32DS/build > /S32DS/build/${PROJ_NAME}.dfxml

# Bundle up the build 
WORKDIR /S32DS/artifacts/
RUN tar -cjf /S32DS/artifacts/${PROJ_NAME}_artifacts.tar.bz2 /S32DS/build

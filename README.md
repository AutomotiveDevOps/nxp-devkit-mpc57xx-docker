# Containerized builds for NXP's DEVKIT-MPC5744 examples.

Examples copied directly from 

    ~/NXP/S32DS_Power_v2.1/eclipse/plugins/com.nxp.s32ds.e200.examples_1.0.0.201911111358/Examples/MPC5744P
    
with no additional modifications to the source, includes or Project_Settings.

## Usage

[Requires [Docker image created from ```AutomotiveDevOps/powerpc-eabivle-gcc-dockerfiles```](https://github.com/AutomotiveDevOps/powerpc-eabivle-gcc-dockerfiles)]

### Cloning & Checkout

```
git clone https://github.com/AutomotiveDevOps/nxp-devkit-mpc57xx-docker.git
cd nxp-devkit-mpc57xx-docker
git checkout DEVKIT-MPC5744P
```

### Build Single Project

Build a single example:

```
cd MPC5744P/ADC_MPC5744P
sh build-5744p.sh
```

### Build All Projects

```
cd MPC5744P
sh build_all.sh
```

**Artifacts will be located in ```artifacts/``` relative to each example's directory.**

## Development

There are only 3 main files for the docker builds: ```Dockerfile```, ```build-5744p.sh```, ```makefiles/devkit_5744p.mk```.

```copy_build_files.py``` copies those 3 files to each example folder.

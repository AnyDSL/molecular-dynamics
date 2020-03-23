# AnyDSL implementation of a neighborlist cutoff scheme optimized for SIMD and GPU architectures

This repository contains a simple, fast, scalable and portable implementation in AnyDSL (https://anydsl.github.io/) for particles short-range interactions simulations using the Lennard-Jones potential, it is entirely based on the miniMD micro-application benchmark.

## Building

To build this package, you must first build AnyDSL (please see https://anydsl.github.io/Build-Instructions.html)

After building AnyDSL, it is recommended that you create a build directory for the installation. Use CMake referring to the path within AnyDSL runtime library that contains the CMake target, as in the following example:

```bash
mkdir -p build
cmake .. -DAnyDSL_runtime_DIR="/path_to/anydsl/runtime/build/share/anydsl/cmake"
# Optional: Include Likwid directory with -DLIKWID_DIR="/path/to/likwid"
```

There are several CMake options you can adjust before compilation, the most important ones are listed as follows:

- **BACKEND:** Backend to compile the application, please use the following: cpu, avx, avx512 or nvvm (default is cpu).
- **COMM\_MAPPING:** MPI variant, please use the following: anydsl or nompi (default is anydsl).
- **USE\_SOA:** Set this option to OFF if you want to use the Array of Structs (AoS) data layout for particle positions, velocities and forces (default is ON).
- **MONITOR\_ONLY\_FORCE\_COMPUTATION:** If you intend to use Likwid to instrument the force computation kernel and do performance monitoring, use this option to include the markers (default is OFF).
- **USE\_WALBERLA\_LOAD\_BALANCING:** Enable this option to use the load balancing mechanism from Walberla, it must be installed (default is OFF).

The Impala compiler generates Thorin intermediate representation that is further compiled using Clang/LLVM. If you want to do cross-compilation or experiment among different compilation flags you can change the CLANG\_FLAGS option.

After adjusting the configurations, simply use the make command to compile the code.

```bash
make -j4 # this uses 4 jobs to compile in parallel
```

## Usage

Currently, one testcase has been implemented based on miniMD setup. Particles are placed on a three dimensional cubic grid and are initialized with a random velocity. Use the following command to run a simulation:

```bash
./md [OPTION]...
```

Available options are:

- **-x, --nx=SIZE:** Number of unit cells in x dimension (default 32).
- **-y, --ny=SIZE:** Number of unit cells in y dimension (default 32).
- **-z, --nz=SIZE:** Number of unit cells in z dimension (default 32).
- **-s, --timesteps=NUMBER:** Number of time steps to be simulated (default 100).
- **-r, --runs=NUMBER:** Number of test runs (default 1).
- **-t, --threads=NUMBER:** Number of threads used for parallelization (default 1).
- **-v, --vtk=DIRECTORY:** If this argument is provided, vtk output files are created in the specified directory (it must exist). For MPI simulations, the rank number is concatenated in the end of this directory name. For example, if you use "--vtk output" in a simulation with 4 MPI ranks, then directories "output[0-3]" are used.
- **-h, --help:** Display help message.

Each unit cells contains 4 particles in the default setup, so the number of particles is given by nx * ny * nz * 4.

Other simulation parameters are currently hardcoded.

# AnyDSL implementation of a neighborlist cutoff scheme optimized for SIMD and GPU architectures

This repository contains a simple, fast, scalable and portable implementation in AnyDSL (https://anydsl.github.io/) for the Lennard-Jones potential using the miniMD benchmark tool as reference.

## Building

To build this package, you must first build AnyDSL (please see https://anydsl.github.io/Build-Instructions.html)

After building AnyDSL, it is recommended that you create a build directory for the installation. Use CMake referring to the path within AnyDSL runtime library that contains the CMake target, as in the following example:

```bash
mkdir -p build
cmake .. -DAnyDSL_runtime_DIR="/path_to/anydsl/runtime/build/share/anydsl/cmake"
# Optional: Include Likwid directory with -DLIKWID_DIR="/path/to/likwid"
```

There are several CMake options you can adjust before compilation, the most important ones are listed as follows:

- **BACKEND:** Backend to compile the application, please use the following: cpu, avx, avx512 or nvvm.
- **USE\_MPI:** Set this option to OFF if you do not intend to use MPI or do not have a MPI compiler wrapper or library available (default is ON).
- **USE\_SOA:** Set this option to OFF if you want to use the Array of Structs (AoS) data layout for particle positions, velocities and forces (default is ON).
- **MONITOR\_ONLY\_FORCE\_COMPUTATION:** If you intend to use Likwid to instrument the force computation kernel and do performance monitoring, use this option to include the markers (default is OFF).

The Impala compiler generates Thorin intermediate representation that is further compiled using Clang/LLVM. If you want to do cross-compilation or experiment among different compilation flags you can change the CLANG\_FLAGS option.

After adjusting the configurations, simply use the make command to compile the code.

```bash
make -j4 # this uses 4 jobs to compile in parallel
```

## Usage

Currently, one testcase has been implemented based on miniMD setup. Particles are placed on a three dimensional cubic grid and are initialized with a random velocity. Use the following command to run a simulation:

```bash
./md x y z timesteps runs threads [-vtk directory]
```

- **x, y, z:** Number of unit cells in each dimension. Each unit cell contains 4 particles in this setup. For example, if x = 10, y = 10 and z = 10 then 4000 particles are created in the grid.
- **timesteps:** Number of time steps to be simulated.
- **runs:** Number of test runs.
- **threads:** Number of threads used for parallelization   
- **-vtk:** If this argument is provided, vtk output files are created in the specified directory (it must exist). For MPI simulations, the rank number is concatenated in the end of this directory name. For example, if you use "-vtk output" in a simulation with 4 MPI ranks, then directories "output[0-3]" are used.

Other simulation parameters are currently hardcoded.

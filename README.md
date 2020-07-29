# tinyMD: An AnyDSL implementation of a neighborlist cutoff scheme optimized for SIMD and GPU architectures

This repository contains tinyMD: a simple, fast, scalable and portable implementation for particles short-range interactions simulations in AnyDSL (https://anydsl.github.io/), it is based on the miniMD micro-application benchmark.

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
- **USE\_MPI:** Use MPI library, just turn it off if there is no MPI library available (default is ON).
- **USE\_WALBERLA\_LOAD\_BALANCING:** Enable this option to use the load balancing mechanism from Walberla, it must be installed (default is OFF).

The Impala compiler generates Thorin intermediate representation that is further compiled using Clang/LLVM. If you want to do cross-compilation or experiment among different compilation flags you can change the CLANG\_FLAGS option.

After adjusting the configurations, simply use the make command to compile the code.

```bash
make -j4 # this uses 4 jobs to compile in parallel
```

## Usage

Currently, four testcases are available:

- **default:** Setup based on miniMD setup, particles are placed on a three dimensional lattice and are initialized with random velocities that attend the initial temperature defined.
- **body_collision:**: Setup for body collision experiments, produce two lattices like the default and initialize the velocities to induce a collision between these lattices.
- **half:** Same setup as default, but just filling half of the grid using an axis in the y dimension to separate the filled and empty regions.
- **granular_gas:** Setup used to evaluate the load balancing feature in a DEM simulation with the Spring-Dashpot contact model. It also fills a lattice in half of the domain, but velocities are set to zero and a diagonal axis separate the filled and empty regions.

Use the following command to run a simulation:

```bash
./md [OPTION]...
```

Available options are:

- **-f, --force_field=STRING:** Force field to use (options are lj and dem, default is lj).
- **-b, --benchmark=STRING:** Benchmark to use (options are default, half, body\_collision and granular\_gas).
- **-x, --nx=SIZE:** Number of unit cells in x dimension (default 32).
- **-y, --ny=SIZE:** Number of unit cells in y dimension (default 32).
- **-z, --nz=SIZE:** Number of unit cells in z dimension (default 32).
- **-s, --timesteps=NUMBER:** Number of time steps to be simulated (default 100).
- **-r, --runs=NUMBER:** Number of test runs (default 1).
- **-t, --threads=NUMBER:** Number of threads used for parallelization (default 1).
- **-a, --algorithm=STRING:** Load balancing algorithm to use.
- **-v, --vtk=DIRECTORY:** If this argument is provided, vtk output files are created in the specified directory (it must exist). For MPI simulations, the rank number is concatenated in the end of this directory name. For example, if you use "--vtk output" in a simulation with 4 MPI ranks, then directories "output[0-3]" are used.
- **--reneigh=NUMBER:** Timesteps to simulate before reneighboring (default 20).
- **--rebalance=NUMBER:** Timesteps to simulate before load balancing (default 100).
- **--dt=REAL:** Timestep size (default 0.005).
- **--temp=REAL:** initial temperature (default 1.44).
- **--cutoff=REAL:** Cutoff radius (default 2.5).
- **--verlet=REAL:** Verlet buffer (default 0.3).
- **--epsilon=REAL:** Epsilon value for Lennard-Jones equation (default 1.0).
- **--sigma=REAL:** Sigma value for Lennard-Jones equation (default 1.0).
- **--damping_n:** Normal damping for DEM force-field (default 0.0).
- **--damping_t:** Tangential damping for DEM force-field (default 0.0).
- **--stiffness:** Stiffness for DEM force-field (default 0.0).
- **--friction:** Friction for DEM force-field (default 0.0).
- **--potmin=REAL:** Potential minimum (default 1.6796).
- **--half_nb:** Compute with half neighbor list.
- **--prebalance:** Perform static load balancing before execution.
- **-h, --help:** Display help message.

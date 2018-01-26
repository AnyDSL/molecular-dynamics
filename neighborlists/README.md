# An AnyDSL implementation of a neighborlist cutoff scheme optimized for SIMD and GPU architectures

## Building
cmake . -DAnyDSL-runtime_DIR="/path_to/anydsl/runtime"  
to use likwid for performance monitoring additionally pass: -DLIKWID_DIR="/path/to/likwid"  
make

## Usage
Currently, only one testcase has been implemened on the CPU. Particles are placed on a three dimensional cubic grid and are initialized with a random velocity.  

./md x y z timesteps runs threads [-vtk /path_to/output_directory]  

x,y,z: Number of particles placed on a grid in each dimension. For example: For x = 10, y = 10, z = 10, 1000 particles are created and placed on a cubic grid  
timesteps: Number of time steps computed  
runs: Number of test runs  
threads: Number of threads used for parallelization   
-vtk: If this argument is provided, vtk output files are created in the directory specified.  
All other simulation parameters are currently hardcoded.   
If you want to do a specific performance monitoring of the force computation kernel, you can enable the "MONITOR_FORCE_COMPUTATION"-flag in CMake.  
Additionally, the number of FLOPS can be directly counted with the flag "COUNT_FLOPS".  

# An AnyDSL implementation of a neighborlist cutoff scheme optimized for SIMD and GPU architectures

## Building
cmake . -DAnyDSL-runtime_DIR="/path_to/anydsl/runtime"  
make

## Usage
Currently, only one testcase has been implemened on the CPU. Particles are placed on a three dimensional cubic grid and are initialized with a random velocity.  

./md gridsize timesteps runs [-vtk /path_to/output_directory]  

gridsize: Number of particles placed on a grid in each dimension. For example: For gridsize = 10, 1000 particles are created and placed on a cubic grid  
timesteps: Number of time steps computed  
runs: Number of test runs
-vtk: If this argument is provided, vtk output files are created in the directory specified.  
All other simulation parameters are currently hardcoded.  

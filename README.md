# AnyDSL-MD: Molecular dynamics based on AnyDSL
## Impala
### Building
cmake . -DAnyDSL-runtime_DIR=<PATH_TO_ANYDSL_RUNTIME> -DLIKWID_DIR=<PATH_TO_LIKWID> -DLIKWID_PERFMON=ON/OFF -DCOUNT_COLLISIONS=ON/OFF   
make  
### Configuration
ccmake .
### Running
./md dt steps particles numthreads [-vtk]  
dt: time step length  
steps: number of time steps  
particles: number of particles  
numthreads: number of threads used  
-vtk: if this argument is provided, vtk output is created in ../impala_vtk 

## C Reference
### Building
cmake . -DLIKWID_DIR=<PATH_TO_LIKWID> -DLIKWID_PERFMON=ON/OFF -DCOUNT_COLLISIONS=ON/OFF  
make  
### Running
./md dt steps particles numthreads [-vtk]  
dt: time step length  
steps: number of time steps  
particles: number of particles  
numthreads: number of threads used  
-vtk: if this argument is provided, vtk output is created in ../c_vtk

## walberla
Runtime wrapper for usage within walberla

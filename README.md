# AnyDSL-MD: Molecular dynamics based on AnyDSL
## Impala
### Building
cmake . -DAnyDSL-runtime_DIR=<PATH_TO_ANYDSL_RUNTIME> -DLIKWID_DIR=<PATH_TO_LIKWID>
### Configuration
ccmake .
### Running
./md dt steps particles [-vtk]  
dt: time step length  
steps: number of time steps  
particles: number of particles  
-vtk: if this argument is provided, vtk output is created in ../impala_vtk 

## C Reference
### Building
cmake . -DAnyDSL-runtime_DIR=<PATH_TO_ANYDSL_RUNTIME> -DLIKWID_DIR=<PATH_TO_LIKWID>
### Running
./md dt steps particles [-vtk]  
dt: time step length  
steps: number of time steps  
particles: number of particles  
-vtk: if this argument is provided, vtk output is created in ../c_vtk

## walberla
Runtime wrapper for usage within walberla

# AnyDSL-MD: Molecular dynamics based on AnyDSL
## Impala
### Building
```sh
cmake . -DAnyDSL-runtime_DIR=<PATH_TO_ANYDSL_RUNTIME> -DLIKWID_DIR=<PATH_TO_LIKWID> -DLIKWID_PERFMON=ON/OFF -DCOUNT_FORCE_EVALUATIONS=ON/OFF -DCHECK_INVARIANTS=ON/OFF   
make
```
### Configuration
```sh
ccmake .
```
### Running
```sh
./md dt steps particles [-vtk]
```
* ```dt```: time step length  
* ```steps```: number of time steps  
* ```particles```: number of particles  
* ```-vtk```: if this argument is provided, vtk output is created in ../impala_vtk 

## C Reference
### Building
```sh
cmake . -DLIKWID_DIR=<PATH_TO_LIKWID> -DLIKWID_PERFMON=ON/OFF -DCOUNT_FORCE_EVALUATIONS=ON/OFF  
make 
```
### Running
./md dt steps particles numthreads [-vtk]  
* ```dt```: time step length  
* ```steps```: number of time steps  
* ```particles```: number of particles  
* ```numthreads```: number of threads used  
* ```-vtk```: if this argument is provided, vtk output is created in ../c_vtk

## walberla
Runtime wrapper for usage within walberla

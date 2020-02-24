az16ahoq@i10hpc2:/scratch/az16ahoq$ head -50 n2-10x10x10-md.e
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Number of particles: 512
Starting run 1
Number of particles: 448
Starting run 1
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
az16ahoq@i10hpc2:/scratch/az16ahoq$ tail -50 n2-10x10x10-md.e
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0




Code Region Average Standard Deviation
grid_initialization   3.34822 ms 0 ms
integration 531.647 ms 0 ms
redistribution  136.809 ms 0 ms
cluster_initialization  96.1162 ms 0 ms
neighborlist_creation 140.551 ms 0 ms
force_computation 955.02  ms 0 ms
deallocation  1.86248 ms 0 ms
copy_data_to_accelerator  3.3181  ms 0 ms
copy_data_from_accelerator  2.64736 ms 0 ms
synchronization 2321.19 ms 0 ms
Total 4192.51 ms 0 ms
Counted number of FLOPS within the force computation: 0
Code Region Average Standard Deviation
grid_initialization   4.24071 ms 0 ms
integration 511.775 ms 0 ms
redistribution  193.419 ms 0 ms
cluster_initialization  83.0101 ms 0 ms
neighborlist_creation 122.375 ms 0 ms
force_computation 896.131 ms 0 ms
deallocation  1.48672 ms 0 ms
copy_data_to_accelerator  2.83818 ms 0 ms
copy_data_from_accelerator  2.17381 ms 0 ms
synchronization 2460.44 ms 0 ms
Total 4277.89 ms 0 ms
Counted number of FLOPS within the force computation: 0
Finished job script on mother superior node i10hpc11.informatik.uni-erlangen.de...
Finished user epilogue on all sister nodes...
Starting user epilogue on mother superior node i10hpc11.informatik.uni-erlangen.de...
Exiting user epilogue on mother superior node i10hpc11.informatik.uni-erlangen.de...


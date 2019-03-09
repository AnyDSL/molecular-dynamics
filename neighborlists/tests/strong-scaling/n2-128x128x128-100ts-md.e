az16ahoq@i10hpc2:/scratch/az16ahoq$ head -50 n2-128x128x128-100ts-md.e
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Number of particles: 274625
Starting run 1
Number of particles: 287300
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
az16ahoq@i10hpc2:/scratch/az16ahoq$ tail -50 n2-128x128x128-100ts-md.e
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
grid_initialization   1561.41 ms 0 ms
integration 487.098 ms 0 ms
redistribution  484.502 ms 0 ms
cluster_initialization  6988.71 ms 0 ms
neighborlist_creation 4096.44 ms 0 ms
force_computation 13637.4 ms 0 ms
deallocation  1042.96 ms 0 ms
copy_data_to_accelerator  1018.56 ms 0 ms
copy_data_from_accelerator  943.639 ms 0 ms
synchronization 7593.41 ms 0 ms
Total 37854.2 ms 0 ms
Counted number of FLOPS within the force computation: 0
Code Region Average Standard Deviation
grid_initialization   1488.06 ms 0 ms
integration 445.564 ms 0 ms
redistribution  487.67  ms 0 ms
cluster_initialization  7158.73 ms 0 ms
neighborlist_creation 3937.35 ms 0 ms
force_computation 12884.6 ms 0 ms
deallocation  975.699 ms 0 ms
copy_data_to_accelerator  1010.29 ms 0 ms
copy_data_from_accelerator  911.564 ms 0 ms
synchronization 8564.82 ms 0 ms
Total 37864.4 ms 0 ms
Counted number of FLOPS within the force computation: 0
Finished job script on mother superior node i10hpc11.informatik.uni-erlangen.de...
Finished user epilogue on all sister nodes...
Starting user epilogue on mother superior node i10hpc11.informatik.uni-erlangen.de...
Exiting user epilogue on mother superior node i10hpc11.informatik.uni-erlangen.de...

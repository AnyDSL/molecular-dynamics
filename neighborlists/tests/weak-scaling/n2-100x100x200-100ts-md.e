az16ahoq@i10hpc2:/scratch/az16ahoq$ head -50 n2-100x100x200-100ts-md.e
Potential minimum at: 1.12246
Potential minimum at: 1.12246
0> xmin = -2.8, xmax = 117.6, ymin = -2.8, ymax = 117.6, zmin = -2.8, zmax = 114.8, cell_spacing = 2.8
1> xmin = -2.8, xmax = 117.6, ymin = -2.8, ymax = 117.6, zmin = 109.2, zmax = 229.6, cell_spacing = 2.8
Number of particles: 1030000
Starting run 1
Number of particles: 1020000
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
az16ahoq@i10hpc2:/scratch/az16ahoq$ tail -50 n2-100x100x200-100ts-md.e
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
grid_initialization   4414.47 ms 0 ms
integration 1826.73 ms 0 ms
redistribution  1137.29 ms 0 ms
cluster_initialization  27110.8 ms 0 ms
neighborlist_creation 12531.1 ms 0 ms
force_computation 41336.6 ms 0 ms
deallocation  3706.28 ms 0 ms
copy_data_to_accelerator  3770.2  ms 0 ms
copy_data_from_accelerator  2909.7  ms 0 ms
synchronization 15754.1 ms 0 ms
Total 114497  ms 0 ms
Counted number of FLOPS within the force computation: 0
Code Region Average Standard Deviation
grid_initialization   4517.9  ms 0 ms
integration 1752.27 ms 0 ms
redistribution  1352.54 ms 0 ms
cluster_initialization  25894.6 ms 0 ms
neighborlist_creation 12231.3 ms 0 ms
force_computation 40780.8 ms 0 ms
deallocation  3797.94 ms 0 ms
copy_data_to_accelerator  3820.42 ms 0 ms
copy_data_from_accelerator  2852.55 ms 0 ms
synchronization 17825.6 ms 0 ms
Total 114826  ms 0 ms
Counted number of FLOPS within the force computation: 0
Finished job script on mother superior node i10hpc10.informatik.uni-erlangen.de...
Finished user epilogue on all sister nodes...
Starting user epilogue on mother superior node i10hpc10.informatik.uni-erlangen.de...
Exiting user epilogue on mother superior node i10hpc10.informatik.uni-erlangen.de...

az16ahoq@i10hpc2:/scratch/az16ahoq$ head -50 n8-100x100x800-100ts-md.e
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
1> xmin = 53.2, xmax = 117.6, ymin = -2.8, ymax = 58.8, zmin = -2.8, zmax = 450.8, cell_spacing = 2.8
3> xmin = 53.2, xmax = 117.6, ymin = 53.2, ymax = 117.6, zmin = -2.8, zmax = 450.8, cell_spacing = 2.8
4> xmin = -2.8, xmax = 58.8, ymin = -2.8, ymax = 58.8, zmin = 445.2, zmax = 901.6, cell_spacing = 2.8
0> xmin = -2.8, xmax = 58.8, ymin = -2.8, ymax = 58.8, zmin = -2.8, zmax = 450.8, cell_spacing = 2.8
5> xmin = 53.2, xmax = 117.6, ymin = -2.8, ymax = 58.8, zmin = 445.2, zmax = 901.6, cell_spacing = 2.8
7> xmin = 53.2, xmax = 117.6, ymin = 53.2, ymax = 117.6, zmin = 445.2, zmax = 901.6, cell_spacing = 2.8
6> xmin = -2.8, xmax = 58.8, ymin = 53.2, ymax = 117.6, zmin = 445.2, zmax = 901.6, cell_spacing = 2.8
2> xmin = -2.8, xmax = 58.8, ymin = 53.2, ymax = 117.6, zmin = -2.8, zmax = 450.8, cell_spacing = 2.8
Number of particles: 1132027
Starting run 1
Number of particles: 1129218
Starting run 1
Number of particles: 1110668
Starting run 1
Number of particles: 1107912
Starting run 1
Number of particles: 1110668
Starting run 1
Number of particles: 1107912
Starting run 1
Number of particles: 1089712
Starting run 1
Number of particles: 1087008
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
az16ahoq@i10hpc2:/scratch/az16ahoq$ tail -50 n8-100x100x800-100ts-md.e
force_computation 46593 ms 0 ms
deallocation  4615.75 ms 0 ms
copy_data_to_accelerator  5004.48 ms 0 ms
copy_data_from_accelerator  5071.23 ms 0 ms
Code Region Average Standard Deviation
grid_initialization   5891.79 ms 0 ms
integration 2471.99 ms 0 ms
redistribution  4112.72 ms 0 ms
cluster_initialization  73580.7 ms 0 ms
neighborlist_creation 19472.9 ms 0 ms
force_computation 46995.8 ms 0 ms
deallocation  5043.13 ms 0 ms
copy_data_to_accelerator  4934.84 ms 0 ms
copy_data_from_accelerator  5007.16 ms 0 ms
synchronization 81586.3 ms 0 ms
Total 249097  ms 0 ms
Counted number of FLOPS within the force computation: 0
synchronization 81483.9 ms 0 ms
Total 248945  ms 0 ms
Counted number of FLOPS within the force computation: 0
Code Region Average Standard Deviation
grid_initialization   6180  ms 0 ms
integration 2565.19 ms 0 ms
redistribution  4428.67 ms 0 ms
cluster_initialization  73938.7 ms 0 ms
neighborlist_creation 18661.8 ms 0 ms
force_computation 41668.6 ms 0 ms
deallocation  4948.34 ms 0 ms
copy_data_to_accelerator  4874.88 ms 0 ms
Code Region Average Standard Deviation
grid_initialization   6191.73 ms 0 ms
integration 2562.76 ms 0 ms
redistribution  5005.4  ms 0 ms
cluster_initialization  74775 ms 0 ms
neighborlist_creation 18364.6 ms 0 ms
force_computation 41978.8 ms 0 ms
deallocation  5041.33 ms 0 ms
copy_data_to_accelerator  4849.68 ms 0 ms
copy_data_from_accelerator  4697.79 ms 0 ms
copy_data_from_accelerator  4882.09 ms 0 ms
synchronization 87621.5 ms 0 ms
Total 249770  ms 0 ms
Counted number of FLOPS within the force computation: 0
synchronization 87351.5 ms 0 ms
Total 250818  ms 0 ms
Counted number of FLOPS within the force computation: 0
Finished job script on mother superior node i10hpc10.informatik.uni-erlangen.de...
Finished user epilogue on all sister nodes...
Starting user epilogue on mother superior node i10hpc10.informatik.uni-erlangen.de...
Exiting user epilogue on mother superior node i10hpc10.informatik.uni-erlangen.de...

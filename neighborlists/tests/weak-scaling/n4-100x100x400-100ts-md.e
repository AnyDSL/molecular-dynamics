az16ahoq@i10hpc2:/scratch/az16ahoq$ head -50 n4-100x100x400-100ts-md.e
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
1> xmin = -2.8, xmax = 117.6, ymin = 53.2, ymax = 117.6, zmin = -2.8, zmax = 226.8, cell_spacing = 2.8
3> xmin = -2.8, xmax = 117.6, ymin = 53.2, ymax = 117.6, zmin = 221.2, zmax = 453.6, cell_spacing = 2.8
2> xmin = -2.8, xmax = 117.6, ymin = -2.8, ymax = 58.8, zmin = 221.2, zmax = 453.6, cell_spacing = 2.8
0> xmin = -2.8, xmax = 117.6, ymin = -2.8, ymax = 58.8, zmin = -2.8, zmax = 226.8, cell_spacing = 2.8
Number of particles: 1070600
Starting run 1
Number of particles: 1075900
Starting run 1
Number of particles: 1055600
Starting run 1
Number of particles: 1050400
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
az16ahoq@i10hpc2:/scratch/az16ahoq$ 
az16ahoq@i10hpc2:/scratch/az16ahoq$ 
az16ahoq@i10hpc2:/scratch/az16ahoq$ tail -50 n4-100x100x400-100ts-md.e
force_computation 37158.1 ms 0 ms
deallocation  3705.2  ms 0 ms
copy_data_to_accelerator  4075.8  ms 0 ms
copy_data_from_accelerator  3901.4  ms 0 ms
synchronization 47168.6 ms 0 ms
Total 153863  ms 0 ms
Counted number of FLOPS within the force computation: 0
Code Region Average Standard Deviation
grid_initialization   4725.3  ms 0 ms
integration 2031.43 ms 0 ms
redistribution  3792.46 ms 0 ms
Code Region Average Standard Deviation
grid_initialization   4718.65 ms 0 ms
integration 2013.69 ms 0 ms
redistribution  2690.7  ms 0 ms
cluster_initialization  32909.7 ms 0 ms
neighborlist_creation 13154.1 ms 0 ms
force_computation 38171.8 ms 0 ms
deallocation  4035.24 ms 0 ms
copy_data_to_accelerator  4504.63 ms 0 ms
copy_data_from_accelerator  4390.59 ms 0 ms
synchronization 46895.6 ms 0 ms
Total 153485  ms 0 ms
Counted number of FLOPS within the force computation: 0
Code Region Average Standard Deviation
grid_initialization   4863.2  ms 0 ms
integration 2055.09 ms 0 ms
redistribution  4087.55 ms 0 ms
cluster_initialization  32596.4 ms 0 ms
neighborlist_creation 12976.5 ms 0 ms
force_computation 37796.5 ms 0 ms
deallocation  4078.03 ms 0 ms
copy_data_to_accelerator  4350.14 ms 0 ms
copy_data_from_accelerator  3588.35 ms 0 ms
synchronization 48030 ms 0 ms
Total 154422  ms 0 ms
Counted number of FLOPS within the force computation: 0
cluster_initialization  32688.7 ms 0 ms
neighborlist_creation 13287.7 ms 0 ms
force_computation 38389.9 ms 0 ms
deallocation  3799.11 ms 0 ms
copy_data_to_accelerator  4178.7  ms 0 ms
copy_data_from_accelerator  3737.16 ms 0 ms
synchronization 46540.7 ms 0 ms
Total 153171  ms 0 ms
Counted number of FLOPS within the force computation: 0
Finished job script on mother superior node i10hpc10.informatik.uni-erlangen.de...
Finished user epilogue on all sister nodes...
Starting user epilogue on mother superior node i10hpc10.informatik.uni-erlangen.de...
Exiting user epilogue on mother superior node i10hpc10.informatik.uni-erlangen.de...

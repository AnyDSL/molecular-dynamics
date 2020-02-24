az16ahoq@i10hpc2:/scratch/az16ahoq$ head -50 n16-128x128x128-100ts-md.e
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Potential minimum at: 1.12246
Number of particles: 41382
Starting run 1
Number of particles: 35937
Starting run 1
Number of particles: 40293
Starting run 1
Number of particles: 38115
Starting run 1
Number of particles: 38115
Starting run 1
Number of particles: 40293
Starting run 1
Number of particles: 41382
Starting run 1
Number of particles: 42735
Starting run 1
Number of particles: 40425
Starting run 1
Number of particles: 43890
Starting run 1
Number of particles: 42735
Starting run 1
Number of particles: 47652
Starting run 1
Number of particles: 43890
Starting run 1
Number of particles: 45177
Starting run 1
Number of particles: 46398
Starting run 1
Number of particles: 46398
Starting run 1
Copy between devices 0 and 0 on platform 0
Copy between devices 0 and 0 on platform 0
az16ahoq@i10hpc2:/scratch/az16ahoq$ tail -50 n16-128x128x128-100ts-md.e
neighborlist_creation 1092.27 ms 0 ms
copy_data_from_accelerator  226.641 ms 0 ms
synchronization 14898 ms 0 ms
Total 44842.1 ms 0 ms
Counted number of FLOPS within the force computation: 0
deallocation  241.659 ms 0 ms
copy_data_to_accelerator  240.58  ms 0 ms
copy_data_from_accelerator  201.897 ms 0 ms
synchronization 13804.7 ms 0 ms
Total 44836.1 ms 0 ms
Counted number of FLOPS within the force computation: 0
Total 44934 ms 0 ms
Counted number of FLOPS within the force computation: 0
force_computation 2957.2  ms 0 ms
deallocation  168.231 ms 0 ms
copy_data_to_accelerator  276.638 ms 0 ms
copy_data_from_accelerator  195.139 ms 0 ms
synchronization 15942.4 ms 0 ms
Total 44974.7 ms 0 ms
Counted number of FLOPS within the force computation: 0
Code Region Average Standard Deviation
grid_initialization   653.349 ms 0 ms
integration 144.381 ms 0 ms
redistribution  535.153 ms 0 ms
cluster_initialization  22559.9 ms 0 ms
neighborlist_creation 1279.32 ms 0 ms
force_computation 2811.77 ms 0 ms
deallocation  187.897 ms 0 ms
copy_data_to_accelerator  228.481 ms 0 ms
copy_data_from_accelerator  187.525 ms 0 ms
synchronization 16455.6 ms 0 ms
Total 45043.4 ms 0 ms
Counted number of FLOPS within the force computation: 0
Code Region Average Standard Deviation
grid_initialization   674.322 ms 0 ms
integration 158.544 ms 0 ms
redistribution  763.386 ms 0 ms
cluster_initialization  22800.8 ms 0 ms
neighborlist_creation 1190.87 ms 0 ms
force_computation 3537.28 ms 0 ms
deallocation  153.57  ms 0 ms
copy_data_to_accelerator  244.642 ms 0 ms
copy_data_from_accelerator  233.496 ms 0 ms
synchronization 15001.4 ms 0 ms
Total 44758.4 ms 0 ms
Counted number of FLOPS within the force computation: 0
Finished job script on mother superior node i10hpc11.informatik.uni-erlangen.de...
Finished user epilogue on all sister nodes...
Starting user epilogue on mother superior node i10hpc11.informatik.uni-erlangen.de...
Exiting user epilogue on mother superior node i10hpc11.informatik.uni-erlangen.de...

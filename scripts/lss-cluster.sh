#!/bin/sh
#PBS -l nodes=4:ppn=32
#PBS -l walltime=8:00:00
#PBS -q normal 
#PBS -M schmitt@localhost -m abe
#PBS -N AnyDSL-MD

. /etc/profile.d/modules.sh
module load openmpi/1.10.4-gnu
cd ~/Research/walberla_build/apps/anydsl-md/walberla
make clean
make
#mpirun -np 128 --bind-to socket ./md_simulation pe_cfg
mpirun --map-by ppr:32:socket --bind-to socket ./md_simulation pe.cfg

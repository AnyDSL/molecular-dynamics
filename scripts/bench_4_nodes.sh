#!/bin/sh
#PBS -l nodes=4:ppn=32
#PBS -l walltime=8:00:00
#PBS -q normal 
#PBS -M jonas.schmitt@fau.de -m abe
#PBS -N md-4-nodes

. /etc/profile.d/modules.sh
module load openmpi/1.10.4-gnu
cd ~/Research/walberla_build/apps/anydsl-md/walberla
make clean
make
mpirun -np 128 --bind-to socket ./md_simulation config_4_nodes.cfg 

#!/bin/sh
#PBS -l nodes=8:ppn=32
#PBS -l walltime=08:00:00
#PBS -q big
#PBS -M jonas.schmitt@fau.de -m abe
#PBS -N anydsl-md

. /etc/profile.d/modules.sh
module load openmpi/1.10.4-gnu
#module load openmpi/1.10.3-gnu
cd ~/Research/walberla_build/apps/anydsl-md/walberla
make clean
make
mpirun -np 256 ./md_simulation pe_config.cfg 

#!/bin/bash
#PBS -l nodes=1:ppn=32
#PBS -l walltime=08:00:00
#PBS -q normal
#PBS -M az16ahoq@fau.de -m abe
#PBS -N testmd /etc/profile.d/modules.sh
#PBS -o /scratch/az16ahoq/$PBS_JOBID.md.e
#PBS -e /scratch/az16ahoq/$PBS_JOBID.md.o

module load openmpi/4.0.0-gnu
#module load openmpi/3.1.3-gcc7.3

np=32
nx=200
ny=200
nz=200
steps=100
runs=1
threads=4

export LD_LIBRARY_PATH=/scratch/az16ahoq
export OMPI_MCA_btl_openib_allow_ib="true"
cd /scratch/az16ahoq
mkdir -p "${PBS_JOBID}"
echo "[$(date +'%Y/%m/%d-%H:%M:%S')] ${PBS_JOBID} -> np=${np}, grid=${nx}x${ny}x${nz}, steps=${steps}, runs=${runs}, threads=${threads}" >> md_jobs.log
#mpirun -np ${np} --bind-to socket valgrind --tool=massif --massif-out-file="${PBS_JOBID}/massif.md.%p" ./md ${nx} ${ny} ${nz} ${steps} ${runs} ${threads}
mpirun -np ${np} --bind-to socket ./md ${nx} ${ny} ${nz} ${steps} ${runs} ${threads}

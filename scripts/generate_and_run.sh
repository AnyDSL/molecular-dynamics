#!/bin/bash

prefix="experiments"
configs="1 2 4 8 16 32 64 128 256 512 1024"
benchmark="default"
force_field="lj"
nx_base=50
ny_base=50
nz_base=50
timesteps=100

function get_nnodes_unit_cells {
    local i=0
    for((a = 1; a < $1; a=$((a * 2)))); do
        if [ $i -eq 0 ]; then
            nx=$((nx * 2))
        elif [ $i -eq 1 ]; then
            ny=$((ny * 2))
        else
            nz=$((nz * 2))
        fi

        i=$(((i + 1) % 3))
    done
}

function write_script {
cat << EOF > $1
#!/bin/bash -l
#SBATCH --job-name=anydsl_md
#SBATCH --time=01:00:00
#SBATCH --nodes=${nodes}
#SBATCH --ntasks-per-core=2
#SBATCH --ntasks-per-node=12
#SBATCH --cpus-per-task=2
#SBATCH --partition=normal
#SBATCH --constraint=gpu

export OMP_NUM_THREADS=\$SLURM_CPUS_PER_TASK
export CRAY_CUDA_MPS=1
module load daint-gpu
srun ./md -b ${benchmark} -f ${force_field} -x ${nx} -y ${ny} -z ${nz} -s ${timesteps}
EOF
}

mkdir -p $prefix

for nodes in $configs; do
    mkdir -p ${prefix}/$nodes
    nx=$nx_base
    ny=$ny_base
    nz=$nz_base
    get_nnodes_unit_cells $nodes
    write_script "$prefix/$nodes/script.sh"    
done

for nodes in $configs; do
    cd ${prefix}/$nodes
    echo $(pwd)
    echo "sbatch script.sh"
    cd ../..
done

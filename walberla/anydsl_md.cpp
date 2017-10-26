#include "anydsl_md.h"

void anydsl_md_reinitialize_blocks(shared_ptr<BlockForest> forest, BlockDataID storageID) {
    uint64_t nBlocks = static_cast<uint64_t>(forest->getNumberOfBlocks());
    uint64_t *ids = new uint64_t[nBlocks];
    uint64_t *storages = new uint64_t[nBlocks];
    double **domains = new double * [nBlocks];
    double **coordinate_shifts = new double *[nBlocks];
    for(size_t i = 0; i < nBlocks; ++i) {
        domains[i] = new double[3];
        coordinate_shifts[i] = new double[3];
    }
    uint64_t *ghost_layers = new uint64_t[nBlocks];
    uint64_t *nParticles_local = new uint64_t[nBlocks];
    uint64_t *nParticles_shadow = new uint64_t[nBlocks];
    
    size_t i = 0;
    for (auto blkIt = forest->begin(); blkIt != forest->end(); ++blkIt) {
        IBlock & currentBlock = *blkIt;
        Storage * storage = currentBlock.getData< Storage >( storageID );
        BodyStorage& localStorage = (*storage)[0];
        BodyStorage& shadowStorage = (*storage)[1];

        // ID
        ids[i] = static_cast<uint64_t>(currentBlock.getId().getID());

        // Storages
        storages[i] = reinterpret_cast<uint64_t>(storage);

        // Domain
        Vec3 min, max;
        auto aabb = currentBlock.getAABB();
        min[0] = aabb.xMin();
        min[1] = aabb.yMin();
        min[2] = aabb.zMin();
        max[0] = aabb.xMax();
        max[1] = aabb.yMax();
        max[2] = aabb.zMax();
        for(size_t d = 0; d < 3; ++d) {
            if(min[d] > 0.0 || min[d] < 0.0) {
                coordinate_shifts[i][d] = -static_cast<double>(min[d]);
                domains[i][d] = static_cast<double>(max[d]) + coordinate_shifts[i][d];
            }
            else  {
                coordinate_shifts[i][d] = 0.0;
                domains[i][d] = static_cast<double>(max[d]);
            }
        }
        // ghost layers
        ghost_layers[i] = 1;

        // Number of particles    
        nParticles_local[i] = static_cast<uint64_t>(localStorage.size());
        nParticles_shadow[i] = static_cast<uint64_t>(shadowStorage.size());
        ++i;
    } 
    c_reinitialize_block_list(nBlocks, ids, storages, domains, coordinate_shifts, ghost_layers, nParticles_local, nParticles_shadow);
    delete[] ids;
    delete[] storages;
    for(i = 0; i < nBlocks; ++i) {
        delete[] domains[i];
        delete[] coordinate_shifts[i];
    }
    delete[] ghost_layers;
    delete[] nParticles_local;
    delete[] nParticles_shadow;
}


void anydsl_md_time_integration(real_t dt, size_t iteration)  {
    c_time_integration(static_cast<double>(dt), static_cast<uint64_t>(iteration));
}


void anydsl_md_time_integration_vector(real_t dt, size_t iteration)  {
    c_time_integration_vector(static_cast<double>(dt), static_cast<uint64_t>(iteration));
}

void anydsl_md_compute_initial_forces() {
    c_compute_initial_forces();
}

void anydsl_md_time_step_first_part(real_t dt) {
    c_time_step_first_part(static_cast<double>(dt));
}


void anydsl_md_time_step_second_part(real_t dt) {
    c_time_step_second_part(static_cast<double>(dt));
}

void anydsl_md_delete_blocks() {
    c_delete_blocks();
}
void anydsl_md_check_invariants() {
    c_check_invariants();
}

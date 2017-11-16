#include "blockforest/all.h"
#include "core/all.h"
#include "domain_decomposition/all.h"

#include <pe/basic.h>
#include <pe/cr/PlainIntegrator.h>
#include <pe/statistics/BodyStatistics.h>
#include <pe/synchronization/SyncNextNeighbors.h>
#include <pe/synchronization/SyncShadowOwners.h>
#include <pe/utility/CreateWorld.h>
#include <pe/vtk/BodyVtkOutput.h>
#include <pe/vtk/SphereVtkOutput.h>


using namespace walberla;
using namespace walberla::pe;

extern "C" {
    void c_reinitialize_block_list(uint64_t, uint64_t *, uint64_t *, double **, double **, uint64_t *, uint64_t *, uint64_t *);
    void c_time_integration(double, uint64_t);
    void c_time_integration_vector(double, uint64_t);
    void c_compute_initial_forces();
    void c_time_step_first_part(double);
    void c_time_step_second_part(double);
    void c_delete_blocks();
    void c_check_invariants();
}

void anydsl_md_reinitialize_blocks(shared_ptr<BlockForest>, BlockDataID); 
void anydsl_md_time_integration(real_t, size_t); 
void anydsl_md_compute_initial_forces();
void anydsl_md_time_step_first_part(real_t); 
void anydsl_md_time_step_second_part(real_t); 
void anydsl_md_delete_blocks();
void anydsl_md_check_invariants();

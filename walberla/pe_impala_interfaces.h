#pragma once
#include <pe/rigidbody/BodyStorage.h>
#include <cstdint>

using namespace walberla;
using namespace walberla::pe;

typedef uint64_t u64;

static BodyStorage *localStorage_ = nullptr;
static BodyStorage *shadowStorage_ = nullptr;

extern "C" {
    void impala_set_storage(u64 storagePtr);

    double impala_LocalBody_get_mass(u64 index); 
    void impala_LocalBody_get_force(u64 index, double *F); 
    void impala_LocalBody_get_position(u64 index, double *X); 
    void impala_LocalBody_get_velocity(u64 index, double *V); 

    void impala_LocalBody_set_mass(u64 index, double m); 
    void impala_LocalBody_set_force(u64 index, double const *F); 
    void impala_LocalBody_set_position(u64 index, double const *X); 
    void impala_LocalBody_set_velocity(u64 index, double const *V); 

    double impala_ShadowBody_get_mass(u64 index); 
    void impala_ShadowBody_get_force(u64 index, double *F); 
    void impala_ShadowBody_get_position(u64 index, double *X); 
    void impala_ShadowBody_get_velocity(u64 index, double *V); 

    void impala_ShadowBody_set_mass(u64 index, double m); 
    void impala_ShadowBody_set_force(u64 index, double const *F); 
    void impala_ShadowBody_set_position(u64 index, double const *X); 
    void impala_ShadowBody_set_velocity(u64 index, double const *V); 
}

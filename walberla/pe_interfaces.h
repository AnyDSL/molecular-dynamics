#include <pe/rigidbody/BodyStorage.h>

using namespace walberla;
using namespace walberla::pe;

typedef uint64_t u64;

static BodyStorage *localStorage_;
static BodyStorage *shadowStorage_;

extern "C" {
    double pe_LocalBody_get_mass(u64 index); 
    void pe_LocalBody_get_force(u64 index, double *F); 
    void pe_LocalBody_get_position(u64 index, double *X); 
    void pe_LocalBody_get_velocity(u64 index, double *V); 

    void pe_LocalBody_set_mass(u64 index, double m); 
    void pe_LocalBody_set_force(u64 index, double const *F); 
    void pe_LocalBody_set_position(u64 index, double const *X); 
    void pe_LocalBody_set_velocity(u64 index, double const *V); 

    double pe_ShadowBody_get_mass(u64 index); 
    void pe_ShadowBody_get_force(u64 index, double *F); 
    void pe_ShadowBody_get_position(u64 index, double *X); 
    void pe_ShadowBody_get_velocity(u64 index, double *V); 

    void pe_ShadowBody_set_mass(u64 index, double m); 
    void pe_ShadowBody_set_force(u64 index, double const *F); 
    void pe_ShadowBody_set_position(u64 index, double const *X); 
    void pe_ShadowBody_set_velocity(u64 index, double const *V); 
}

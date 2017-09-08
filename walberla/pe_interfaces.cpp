#include "pe_interfaces.h"

double pe_LocalBody_get_mass(u64 index) {
    BodyStorage::SizeType const i = static_cast<BodyStorage::SizeType>(index);
    auto body = localStorage_->at(i);
    return static_cast<double>(body->getMass());
}
void pe_LocalBody_get_force(u64 index, double *F) {
    BodyStorage::SizeType const i = static_cast<BodyStorage::SizeType>(index);
    auto body = localStorage_->at(i);
    Vec3 force = body->getForce();
    for(u64 d = 0; d < 3; ++d) {
        F[d] = static_cast<double>(force[d]);
    }

}
void pe_LocalBody_get_position(u64 index, double *X) {} 
void pe_LocalBody_get_velocity(u64 index, double *V) {} 

void pe_LocalBody_set_mass(u64 index, double m) {} 
void pe_LocalBody_set_force(u64 index, double const *F) {
    BodyStorage::SizeType const i = static_cast<BodyStorage::SizeType>(index);
    auto body = localStorage_->at(i);
    Vec3 force;
    for(u64 d = 0; d < 3; ++d) {
        force[d] = static_cast<double>(F[d]);
    }
    body->setForce(force);
}
void pe_LocalBody_set_position(u64 index, double const *X) {} 
void pe_LocalBody_set_velocity(u64 index, double const *V) {} 

double pe_ShadowBody_get_mass(u64 index) {
    BodyStorage::SizeType const i = static_cast<BodyStorage::SizeType>(index);
    auto body = localStorage_->at(i);
    return static_cast<double>(body->getMass()); 
} 
void pe_ShadowBody_get_force(u64 index, double *F) {} 
void pe_ShadowBody_get_position(u64 index, double *X) {} 
void pe_ShadowBody_get_velocity(u64 index, double *V) {} 

void pe_ShadowBody_set_mass(u64 index, double m) {} 
void pe_ShadowBody_set_force(u64 index, double const *F) {} 
void pe_ShadowBody_set_position(u64 index, double const *X) {} 
void pe_ShadowBody_set_velocity(u64 index, double const *V) {} 


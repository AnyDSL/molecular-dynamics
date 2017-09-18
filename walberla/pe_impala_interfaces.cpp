#include "pe_impala_interfaces.h"


void impala_set_storage(u64 storage) {
    Storage * storagePtr = reinterpret_cast<Storage *>(storage);
    localStorage_ = &((*storagePtr)[0]);
    shadowStorage_ = &((*storagePtr)[1]);
}

// Local Storage interface functions

double impala_LocalBody_get_mass(u64 index) {
    BodyStorage::SizeType const i = static_cast<BodyStorage::SizeType>(index);
    auto body = localStorage_->at(i);
    return static_cast<double>(body->getMass());
}
void impala_LocalBody_get_force(u64 index, double *F) {
    BodyStorage::SizeType const i = static_cast<BodyStorage::SizeType>(index);
    auto body = localStorage_->at(i);
    Vec3 force = body->getForce();
    for(u64 d = 0; d < 3; ++d) {
        F[d] = static_cast<double>(force[d]);
    }

}
void impala_LocalBody_get_position(u64 index, double *X) {
    BodyStorage::SizeType const i = static_cast<BodyStorage::SizeType>(index);
    auto body = localStorage_->at(i);
    Vec3 position = body->getPosition();
    for(u64 d = 0; d < 3; ++d) {
        X[d] = static_cast<double>(position[d]);
    }
} 
void impala_LocalBody_get_velocity(u64 index, double *V) {
    BodyStorage::SizeType const i = static_cast<BodyStorage::SizeType>(index);
    auto body = localStorage_->at(i);
    Vec3 velocity = body->getLinearVel();
    for(u64 d = 0; d < 3; ++d) {
        V[d] = static_cast<double>(velocity[d]);
    }
} 

void impala_LocalBody_set_mass(u64, double) {
    std::cerr << "Setting the mass is not supported! Initialize the corresponding pe body instead!" << std::endl;
} 
void impala_LocalBody_set_force(u64 index, double const *F) {
    BodyStorage::SizeType const i = static_cast<BodyStorage::SizeType>(index);
    auto body = localStorage_->at(i);
    Vec3 force;
    for(u64 d = 0; d < 3; ++d) {
        force[d] = static_cast<real_t>(F[d]);
    }
    body->setForce(force);
}
void impala_LocalBody_set_position(u64 index, double const *X) {
    BodyStorage::SizeType const i = static_cast<BodyStorage::SizeType>(index);
    auto body = localStorage_->at(i);
    Vec3 position;
    for(u64 d = 0; d < 3; ++d) {
        position[d] = static_cast<real_t>(X[d]);
    }
    body->setPosition(position);
} 
void impala_LocalBody_set_velocity(u64 index, double const *V) {
    BodyStorage::SizeType const i = static_cast<BodyStorage::SizeType>(index);
    auto body = localStorage_->at(i);
    Vec3 velocity;
    for(u64 d = 0; d < 3; ++d) {
        velocity[d] = static_cast<real_t>(V[d]);
    }
    body->setLinearVel(velocity);

} 


// Shadow Storage interface functions

double impala_ShadowBody_get_mass(u64 index) {
    BodyStorage::SizeType const i = static_cast<BodyStorage::SizeType>(index);
    auto body = shadowStorage_->at(i);
    return static_cast<double>(body->getMass());
}
void impala_ShadowBody_get_force(u64 index, double *F) {
    BodyStorage::SizeType const i = static_cast<BodyStorage::SizeType>(index);
    auto body = shadowStorage_->at(i);
    Vec3 force = body->getForce();
    for(u64 d = 0; d < 3; ++d) {
        F[d] = static_cast<double>(force[d]);
    }

}
void impala_ShadowBody_get_position(u64 index, double *X) {
    BodyStorage::SizeType const i = static_cast<BodyStorage::SizeType>(index);
    auto body = shadowStorage_->at(i);
    Vec3 position = body->getPosition();
    for(u64 d = 0; d < 3; ++d) {
        X[d] = static_cast<double>(position[d]);
    }
} 
void impala_ShadowBody_get_velocity(u64 index, double *V) {
    BodyStorage::SizeType const i = static_cast<BodyStorage::SizeType>(index);
    auto body = shadowStorage_->at(i);
    Vec3 velocity = body->getLinearVel();
    for(u64 d = 0; d < 3; ++d) {
        V[d] = static_cast<double>(velocity[d]);
    }
} 

void impala_ShadowBody_set_mass(u64, double) {
    std::cerr << "Setting the mass is not supported! Initialize the corresponding pe body instead!" << std::endl;
} 
void impala_ShadowBody_set_force(u64 index, double const *F) {
    BodyStorage::SizeType const i = static_cast<BodyStorage::SizeType>(index);
    auto body = shadowStorage_->at(i);
    Vec3 force;
    for(u64 d = 0; d < 3; ++d) {
        force[d] = static_cast<real_t>(F[d]);
    }
    body->setForce(force);
}
void impala_ShadowBody_set_position(u64 index, double const *X) {
    BodyStorage::SizeType const i = static_cast<BodyStorage::SizeType>(index);
    auto body = shadowStorage_->at(i);
    Vec3 position;
    for(u64 d = 0; d < 3; ++d) {
        position[d] = static_cast<real_t>(X[d]);
    }
    body->setPosition(position);
} 
void impala_ShadowBody_set_velocity(u64 index, double const *V) {
    BodyStorage::SizeType const i = static_cast<BodyStorage::SizeType>(index);
    auto body = shadowStorage_->at(i);
    Vec3 velocity;
    for(u64 d = 0; d < 3; ++d) {
        velocity[d] = static_cast<real_t>(V[d]);
    }
    body->setLinearVel(velocity);

}


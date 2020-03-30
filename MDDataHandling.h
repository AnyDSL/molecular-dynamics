#include <blockforest/BlockForest.h>
#include <blockforest/BlockDataHandling.h>

namespace walberla {

namespace internal {

class ParticleDeleter {
    friend bool operator==(const ParticleDeleter& lhs, const ParticleDeleter& rhs);

public:
    ParticleDeleter(const math::AABB& aabb) : aabb_(aabb) {}
    ~ParticleDeleter() { md_clear_domain(aabb_.xMin(), aabb_.xMax(), aabb_.yMin(), aabb_.yMax(), aabb_.zMin(), aabb_.zMax()); }

private:
    math::AABB aabb_;
};

inline bool operator==(const ParticleDeleter& lhs, const ParticleDeleter& rhs) {
    return lhs.aabb_ == rhs.aabb_;
}

} // namespace internal

class MDDataHandling : public blockforest::BlockDataHandling<internal::ParticleDeleter>{

public:
    MDDataHandling() {}
    virtual ~MDDataHandling() {}

    virtual internal::ParticleDeleter *initialize(IBlock *const block) WALBERLA_OVERRIDE {
        return new internal::ParticleDeleter(block->getAABB());
    }

    virtual void serialize(IBlock *const block, const BlockDataID&, mpi::SendBuffer& buffer) WALBERLA_OVERRIDE {
        uint_t packed_particles = 0;
        auto ptr = buffer.allocate<uint_t>();

        for(int i = 0; i < md_get_number_of_particles(); ++i) {
            double px, py, pz;

            md_get_position(i, &px, &py, &pz);

            if(block->getAABB().contains(px, py, pz)) {
                double vx, vy, vz;

                md_get_velocity(i, &vx, &vy, &vz);

                buffer << md_get_mass(i);
                buffer << px;
                buffer << py;
                buffer << pz;
                buffer << vx;
                buffer << vy;
                buffer << vz;
                packed_particles++;
            }
        }

        *ptr = packed_particles;
    }

    virtual internal::ParticleDeleter* deserialize(IBlock *const block) WALBERLA_OVERRIDE {
        return initialize(block);
    }

    virtual void deserialize(IBlock *const block, const BlockDataID& id, mpi::RecvBuffer& buffer) WALBERLA_OVERRIDE {
        deserializeImpl(block, id, buffer);
    }

    virtual void serializeCoarseToFine(
        Block *const block,
        const BlockDataID&,
        mpi::SendBuffer& buffer,
        const uint_t child) WALBERLA_OVERRIDE {

        const auto child_id = BlockID(block->getId(), child);
        const auto child_aabb = block->getForest().getAABBFromBlockId(child_id);
        uint_t packed_particles = 0;

        auto ptr = buffer.allocate<uint_t>();

        for(int i = 0; i < md_get_number_of_particles(); ++i) {
            double px, py, pz;

            md_get_position(i, &px, &py, &pz);

            if(block->getAABB().contains(px, py, pz) && child_aabb.contains(px, py, pz)) {
                double vx, vy, vz;

                md_get_velocity(i, &vx, &vy, &vz);

                buffer << md_get_mass(i);
                buffer << px;
                buffer << py;
                buffer << pz;
                buffer << vx;
                buffer << vy;
                buffer << vz;
                packed_particles++;
            }
        }

        *ptr = packed_particles;
    }

    virtual void serializeFineToCoarse(Block *const block, const BlockDataID&, mpi::SendBuffer& buffer) WALBERLA_OVERRIDE {
        uint_t packed_particles = 0;
        auto ptr = buffer.allocate<uint_t>();

        for(int i = 0; i < md_get_number_of_particles(); ++i) {
            double px, py, pz;

            md_get_position(i, &px, &py, &pz);

            if(block->getAABB().contains(px, py, pz)) {
                double vx, vy, vz;

                md_get_velocity(i, &vx, &vy, &vz);

                buffer << md_get_mass(i);
                buffer << px;
                buffer << py;
                buffer << pz;
                buffer << vx;
                buffer << vy;
                buffer << vz;
                packed_particles++;
            }
        }

        *ptr = packed_particles;
    }

    virtual internal::ParticleDeleter *deserializeCoarseToFine(Block *const block) WALBERLA_OVERRIDE {
        return initialize(block);
    }

    virtual internal::ParticleDeleter *deserializeFineToCoarse(Block *const block) WALBERLA_OVERRIDE {
        return initialize(block);
    }

    virtual void deserializeCoarseToFine(Block *const block, const BlockDataID& id, mpi::RecvBuffer& buffer) WALBERLA_OVERRIDE {
        deserializeImpl(block, id, buffer);
    }

    virtual void deserializeFineToCoarse(
        Block *const block,
        const BlockDataID& id,
        mpi::RecvBuffer& buffer,
        const uint_t) WALBERLA_OVERRIDE {

        deserializeImpl(block, id, buffer);
    }

private:
    void deserializeImpl(IBlock *const block, const BlockDataID&, mpi::RecvBuffer& buffer) {
        uint_t nparticles;
        buffer >> nparticles;

        while(nparticles > 0) {
            double mass, px, py, pz, vx, vy, vz;

            buffer >> mass;
            buffer >> px;
            buffer >> py;
            buffer >> pz;
            buffer >> vx;
            buffer >> vy;
            buffer >> vz;

            if(!block->getAABB().contains(px, py, pz)) {
                WALBERLA_ABORT("deserializeImpl: particle is not within domain!\n");
            }

            md_create_particle(mass, px, py, pz, vx, vy, vz);
            --nparticles; 
        }
    }
};

} // namespace walberla

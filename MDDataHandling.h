#include <blockforest/BlockForest.h>
#include <blockforest/BlockDataHandling.h>

namespace walberla {

namespace internal {

class ParticleDeleter {
    friend bool operator==(const ParticleDeleter& lhs, const ParticleDeleter& rhs);

public:
    ParticleDeleter(const math::AABB& aabb) : aabb_(aabb) {}
    ~ParticleDeleter() {}

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

    virtual void serialize(IBlock *const block, const BlockDataID& id, mpi::SendBuffer& buffer) WALBERLA_OVERRIDE {
        serializeImpl(static_cast<Block *const>(block), id, buffer, 0, false);
    }

    virtual internal::ParticleDeleter* deserialize(IBlock *const block) WALBERLA_OVERRIDE {
        return initialize(block);
    }

    virtual void deserialize(IBlock *const block, const BlockDataID& id, mpi::RecvBuffer& buffer) WALBERLA_OVERRIDE {
        deserializeImpl(block, id, buffer);
    }

    virtual void serializeCoarseToFine(Block *const block, const BlockDataID& id, mpi::SendBuffer& buffer, const uint_t child)
        WALBERLA_OVERRIDE {
        serializeImpl(block, id, buffer, child, true);
    }

    virtual void serializeFineToCoarse(Block *const block, const BlockDataID& id, mpi::SendBuffer& buffer) WALBERLA_OVERRIDE {
        serializeImpl(block, id, buffer, 0, false);
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

    virtual void deserializeFineToCoarse(Block *const block, const BlockDataID& id, mpi::RecvBuffer& buffer, const uint_t)
        WALBERLA_OVERRIDE {
        deserializeImpl(block, id, buffer);
    }

private:
    void serializeImpl(Block *const block, const BlockDataID&, mpi::SendBuffer& buffer, const uint_t child, bool check_child) {
        const auto aabb = block->getAABB();
        auto ptr = buffer.allocate<uint_t>();
        double aabb_check[6], aabb_child_check[6];
        int nparticles;

        aabb_check[0] = aabb.xMin();
        aabb_check[1] = aabb.xMax();
        aabb_check[2] = aabb.yMin();
        aabb_check[3] = aabb.yMax();
        aabb_check[4] = aabb.zMin();
        aabb_check[5] = aabb.zMax();

        if(check_child) {
            const auto child_id = BlockID(block->getId(), child);
            const auto child_aabb = block->getForest().getAABBFromBlockId(child_id);

            aabb_child_check[0] = child_aabb.xMin();
            aabb_child_check[1] = child_aabb.xMax();
            aabb_child_check[2] = child_aabb.yMin();
            aabb_child_check[3] = child_aabb.yMax();
            aabb_child_check[4] = child_aabb.zMin();
            aabb_child_check[5] = child_aabb.zMax();
        }

        nparticles = md_serialize_particles(aabb_check, aabb_child_check, check_child);

        for(int i = 0; i < nparticles * 7; ++i) {
            buffer << md_get_send_buffer_value(i);
        }

        *ptr = (uint_t) nparticles;
    }

    void deserializeImpl(IBlock *const, const BlockDataID&, mpi::RecvBuffer& buffer) {
        uint_t nparticles;
        buffer >> nparticles;
        md_deserialize_particles((double *) buffer.ptr(), (int) nparticles);
    }
};

} // namespace walberla

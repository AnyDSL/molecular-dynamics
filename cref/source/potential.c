#include <potential.h>

#ifdef COUNT_COLLISIONS
#define count_collisions true
#else
#define count_collisions false
#endif

static size_t collisions_ = 1;

size_t get_number_of_collisions() {
    return collisions_ - 1;
}

void force(Particle* p1, Particle* p2, bool const write1, bool const write2, Constants const constants) {
    real r = 0.0;
    real dist[DIM];
    for(size_t d = 0; d < DIM; ++d) {
        dist[d] = p2->x[d] - p1->x[d];
        r += sqr(dist[d]);
    }
    if(r < constants.r_cut_sqr) {
        if(count_collisions) {
            if(collisions_ > 0)// overflow detection
                collisions_ += 1;
        }
        real const r8_inv = 1.0/sqr(sqr(r));
        real const f = constants.tmp1 * r8_inv * (1.0 - r*r8_inv*constants.tmp2);
        real F[DIM];
        for(size_t d = 0; d < DIM; ++d) {
            F[d] = f * dist[d];
        }
        if(write1) {
            for(size_t d = 0; d < DIM; ++d) {
                p1->F[d] += F[d];
            }
        }
        if(write2) {
            for(size_t d = 0; d < DIM; ++d) {
                p2->F[d] -= F[d];
            }
        }
    }
}

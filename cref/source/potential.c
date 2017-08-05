#include <potential.h>


void force(Particle* p1, Particle* p2, bool const write1, bool const write2, Constants const constants) {
    real r = 0.0;
    real dist[DIM];
    for(size_t d = 0; d < DIM; ++d) {
        dist[d] = p2->x[d] - p1->x[d];
        r += sqr(dist[d]);
    }
    if(r <= sqr(constants.r_cut)) {
        real s = sqr(constants.sigma) / r;
        s = sqr(s)*s;
        real f = 24.0 * constants.epsilon * s / r * (1.0 - 2.0 * s);
        real tmp[DIM];
        for(size_t d = 0; d < DIM; ++d) {
            tmp[d] = f * dist[d];
        }
        if(write1) {
            for(size_t d = 0; d < DIM; ++d) {
                p1->F[d] += tmp[d];
            }
        }
        if(write2) {
            for(size_t d = 0; d < DIM; ++d) {
                p2->F[d] -= tmp[d];
            }
        }
    }
}

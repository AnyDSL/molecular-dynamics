#include <common.h>
#include <integration.h>

void update_x(Particle * restrict p, real const dt) {
    real const a = dt * 0.5 / p->m;
    for(size_t d = 0; d < DIM; ++d) {
        p->x[d] += dt * (p->v[d] + a * p->F[d]);
        p->F_old[d] = p->F[d];
    }
}

void update_v(Particle * restrict p, real const dt) {
    real const a = dt * 0.5 / p->m;
    for(size_t d = 0; d < DIM; ++d) {
        p->v[d] += a * (p->F[d] + p->F_old[d]);
    }
}

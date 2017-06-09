#include <boundary.h>

/*
void boundary(Particle *restrict p, ParticleSystem P) {
    real const lower = P.ghost_layer * P.constants.r_cut;
    for(size_t d = 0; d < DIM; ++d){
        real const upper = P.l[d] - lower;
        if(p->x[d] < lower) {
            p->x[d] = lower+EPS;
        }
        else if(p->x[d] > upper) {
            p->x[d] = upper-EPS;
        }
    }

}
*/
void boundary(Particle *restrict p, ParticleSystem P) {
    real const offset = P.ghost_layer * P.constants.r_cut;
    for(size_t d = 0; d < DIM; ++d){
        if(p->x[d] + offset < 0.0) {
            p->x[d] = EPS - offset;
        }
        else if(p->x[d] + offset > P.l[d]) {
            p->x[d] = P.l[d] - offset - EPS;
        }
    }

}

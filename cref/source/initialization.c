#include <allocate.h>
#include <math.h>
#include <common.h>
#include <potential.h>
#include <datastructures.h>

void init_constants(Constants *constants) {
    constants->r_cut = 2.5;
    constants->sigma = 1.0;
    constants->epsilon = 5.0;
}

void init_particle_system(double l[DIM], Constants constants, ParticleSystem *P) {
    size_t limit1[DIM], limit2[DIM];
    size_t np1 = 1, np2 = 1;
    for(size_t d = 0; d < DIM; ++d) {
        limit1[d] = 10;
        limit2[d] = 10;
    }
    limit1[0] = 100;
    for(size_t d = 0; d < DIM; ++d) {
        np1 *= limit1[d];
        np2 *= limit2[d];
    }

    allocate_particle_system(np1+np2, l, 1, constants, P);
    size_t ip[DIM];
    real base[DIM];
    base[0] = 50.0;
    base[1] = 100.0;
    base[2] = 100.0;
    real const factor = pow(2.0, 1.0/6.0)*P->constants.sigma;
    for(ip[0] = 0; ip[0] < limit1[0]; ++ip[0]) {
        for(ip[1] = 0; ip[1] < limit1[1]; ++ip[1]) {
            for(ip[2] = 0; ip[2] < limit1[2]; ++ip[2]) {
                ParticleList *node = (ParticleList *)allocate(sizeof(ParticleList));
                node->p.m = 1.0;
                for(size_t d = 0; d < DIM; ++d) {
                    node->p.v[d] = 0.0;
                    node->p.x[d] = base[d] + (real)ip[d] * factor;
                }
                size_t jc[DIM];

                for(size_t d = 0; d < DIM; ++d) {
                    jc[d] = (size_t)floor(node->p.x[d] * P->nc[d] / P->l[d]);
                }
                insertNode(&P->grid[compute_index(jc, P->nc)], node);
            }
        }
    }
    base[0] = 100.0;
    base[1] = 125.0;
    base[2] = 100.0;

    for(ip[0] = 0; ip[0] < limit2[0]; ++ip[0]) {
        for(ip[1] = 0; ip[1] < limit2[1]; ++ip[1]) {
            for(ip[2] = 0; ip[2] < limit2[2]; ++ip[2]) {
                ParticleList *node = (ParticleList *)allocate(sizeof(ParticleList));
                node->p.m = 1.0;
                for(size_t d = 0; d < DIM; ++d) {
                    node->p.v[d] = 0.0;
                    node->p.x[d] = base[d] + (real)ip[d] * factor;
                }
                node->p.v[1] = -300.0;
                size_t jc[DIM];

                for(size_t d = 0; d < DIM; ++d) {
                    jc[d] = (size_t)floor(node->p.x[d] * P->nc[d] / P->l[d]);
                }
                insertNode(&P->grid[compute_index(jc, P->nc)], node);
            }
        }
    }
    init_addresses(P);
}



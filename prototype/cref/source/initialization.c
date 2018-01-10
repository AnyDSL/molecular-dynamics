
#include <math.h>
#include <common.h>
#include <potential.h>
#include <datastructures.h>
#include "allocate.h"
#include "random.h"

static real const V_MAX = 10;

void init_constants(Constants *constants) {
    constants->r_cut = 2.5;
    constants->sigma = 1.0;
    constants->epsilon = 5.0;
    real const sigma3 = constants->sigma*constants->sigma*constants->sigma;
    real const sigma6 = sigma3 * sigma3;
    constants->r_cut_sqr = sqr(constants->r_cut);
    constants->tmp1 = 24.0*constants->epsilon*sigma6;
    constants->tmp2 = 2.0*sigma6;
}

void init_body_collision(size_t const np, double l[DIM], Constants constants, ParticleSystem *P) {
    size_t limit1[DIM], limit2[DIM];
    size_t N = (size_t)floor(pow(np / 11.0, 1.0/3.0));
    for(size_t d = 0; d < DIM; ++d) {
        limit1[d] = N;
        limit2[d] = N;
    }
    limit1[0] = limit1[0] * 10;
    size_t np1 = 1, np2 = 1;
    for(size_t d = 0; d < DIM; ++d) {
        np1 *= limit1[d];
        np2 *= limit2[d];
    }

    allocate_particle_system(np1+np2, l, 1, constants, P);
    size_t ip[DIM];
    real base[DIM];
    real const factor = pow(2.0, 1.0/6.0)*P->constants.sigma;
    base[0] = l[0] / 2.0 - limit1[0] * factor / 2.0;
    base[1] = 100.0;
    base[2] = 100.0;
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
                compute_cell_position(&node->p, P, jc);
                insertNode(&P->grid[compute_index(jc, P->nc)], node);
            }
        }
    }
    base[0] = l[0] / 2.0 - limit1[0] * factor / 2.0;
    base[1] = 115.0;
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
                node->p.v[1] = -V_MAX;
                size_t jc[DIM];

                real const offset = constants.r_cut * P->ghost_layer;
                for(size_t d = 0; d < DIM; ++d) {
                    jc[d] = (size_t)floor((node->p.x[d] + offset) * P->nc[d] / P->l[d]);
                }
                insertNode(&P->grid[compute_index(jc, P->nc)], node);
            }
        }
    }
    init_addresses(P);
}

void init_random(size_t const np, double l[DIM], Constants constants, ParticleSystem *P) {

    c_random_seed(0);
    allocate_particle_system(np, l, 1, constants, P);
    for(size_t i = 0; i < np; ++i) {

        ParticleList *node = (ParticleList *)allocate(sizeof(ParticleList));
        node->p.m = 1.0;
        real const tmp = 2.0 * V_MAX * c_random() - V_MAX;
        real norm = 0.0;
        real V[DIM];
        for(size_t d = 0; d < DIM; ++d) {
            node->p.x[d] = l[d] * c_random();
            V[d] = 2.0 * c_random() - 1.0;
            norm += V[d]*V[d];
        }
        norm = sqrt(norm);
        for(size_t d = 0; d < DIM; ++d) {
            node->p.v[d] = V[d] / norm * tmp;
        }
        size_t jc[DIM];
        compute_cell_position(&node->p, P, jc);
        insertNode(&P->grid[compute_index(jc, P->nc)], node);
    }

    init_addresses(P);
}

void init_grid(size_t const np, double l[DIM], Constants constants, ParticleSystem *P) {
    c_random_seed(0);
    size_t limit[DIM];
    real N = floor(pow(np, 1.0/3.0+EPS));
    real spacing = 2.0*constants.r_cut;
    real l_new[DIM];
    for(size_t d = 0; d < DIM; ++d) {
        l_new[d] = (N+1.0)*spacing;
        limit[d] = (size_t)N;
    }
    allocate_particle_system(np, l_new, 1, constants, P);
    size_t ip[DIM];
    size_t pos = 0;
    for(ip[0] = 0; ip[0] < limit[0]; ++ip[0]) {
        for(ip[1] = 0; ip[1] < limit[1]; ++ip[1]) {
            for(ip[2] = 0; ip[2] < limit[2]; ++ip[2]) {
                ParticleList *node = (ParticleList *)allocate(sizeof(ParticleList));
                node->p.m = 1.0;
                for(size_t d = 0; d < DIM; ++d) {
                    node->p.x[d] = spacing + ip[d] * spacing;
                }
                real const tmp = 2.0 * V_MAX * c_random() - V_MAX;
                real norm = 0.0;
                real V[DIM];
                for(size_t d = 0; d < DIM; ++d) {
                    V[d] = 2.0 * c_random() - 1.0;
                    norm += V[d]*V[d];
                }
                norm = sqrt(norm);
                for(size_t d = 0; d < DIM; ++d) {
                    node->p.v[d] = V[d] / norm * tmp;
                }
                size_t jc[DIM];
                compute_cell_position(&node->p, P, jc);
                insertNode(&P->grid[compute_index(jc, P->nc)], node);
                ++pos;
            }
        }
    }
    for(size_t i = pos; i < np; ++i) {
        ParticleList *node = (ParticleList *)allocate(sizeof(ParticleList));
        node->p.m = 1.0;
        for(size_t d = 0; d < DIM; ++d) {
            node->p.x[d] = l_new[d] * c_random();
        }
        real const tmp = 2.0 * V_MAX * c_random() - V_MAX;
        real norm = 0.0;
        real V[DIM];
        for(size_t d = 0; d < DIM; ++d) {
            V[d] = 2.0 * c_random() - 1.0;
            norm += V[d]*V[d];
        }
        norm = sqrt(norm);
        for(size_t d = 0; d < DIM; ++d) {
            node->p.v[d] = V[d] / norm * tmp;
        }
        size_t jc[DIM];
        compute_cell_position(&node->p, P, jc);
        insertNode(&P->grid[compute_index(jc, P->nc)], node);
    }


    init_addresses(P);
}



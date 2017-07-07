#pragma once
#include <stdint.h>
#include <allocate.h>
#include <common.h>
#include <potential.h>


void insertNode(ParticleList **root, ParticleList *pl);

void removeNode(ParticleList **root);

typedef ParticleList* Cell;

size_t compute_index(const size_t ic[DIM], const size_t nc[DIM]);

typedef struct ParticleSystem {
    size_t np;
    size_t nc[DIM];
    size_t ghost_layer;
    size_t start[DIM];
    size_t end[DIM];
    real l[DIM];
    real tmp[DIM];
    real offset;
    Cell *grid;
    Constants constants;
    uintptr_t *addresses;
} ParticleSystem;

void compute_cell_position(Particle *p, ParticleSystem *P, size_t jc[DIM]);

void allocate_particle_system(size_t np, real l[DIM], size_t ghost_layer, Constants constants, ParticleSystem *P);

void deallocate_particle_system(ParticleSystem P);

void init_addresses(ParticleSystem *P);

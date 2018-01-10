#pragma once
#include <stdlib.h>
#include <stdint.h>
#include <fileIO.h>
#define DIM 3
#define EPS 1e-12
typedef double real;

typedef struct Particle {
    real m;
    real x[DIM];
    real v[DIM];
    real F[DIM];
    real F_old[DIM];
} Particle;

typedef struct ParticleList {
    Particle p;
    struct ParticleList *next;
} ParticleList;

void fprint_vector(uintptr_t fp, real v[DIM]);

real sqr(real const);

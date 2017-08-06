#pragma once
#include <stdbool.h>
#include <common.h>

typedef struct {
    real r_cut;
    real sigma;
    real epsilon;
    real tmp1;
    real tmp2;
} Constants;

size_t get_number_of_collisions();
void force(Particle * restrict p1, Particle * restrict p2, bool const write1, bool const write2, Constants const constants);

#pragma once
#include <stdbool.h>
#include <common.h>

typedef struct {
    real r_cut;
    real sigma;
    real epsilon;
} Constants;


void force(Particle * restrict p1, Particle * restrict p2, bool const write1, bool const write2, Constants const constants);

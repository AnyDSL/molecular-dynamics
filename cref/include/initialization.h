#pragma once
#include <common.h>
#include <potential.h>
#include <datastructures.h>

void init_constants(Constants *constants);
void init_body_collision(size_t const np, real l[DIM], Constants constants, ParticleSystem *P);

void init_random(size_t const np, real l[DIM], Constants constants, ParticleSystem *P);

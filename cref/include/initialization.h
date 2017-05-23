#pragma once
#include <common.h>
#include <potential.h>
#include <datastructures.h>

void init_constants(Constants *constants);
void init_particle_system(real l[DIM], Constants constants, ParticleSystem *P);

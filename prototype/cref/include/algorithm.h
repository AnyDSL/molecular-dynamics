#pragma once
#include <common.h>
#include <datastructures.h>
#include <potential.h>

void compute_force(ParticleSystem P);
void move_particles(ParticleSystem P);
void update_coordinates(ParticleSystem P, real const dt);
void update_velocities(ParticleSystem P, real const dt);
void fprint_particle_system(unsigned char fname[], size_t step, ParticleSystem P);

#pragma once
#include <common.h>
#include <datastructures.h>

void run_simulation(real l[DIM], real const dt, real const t_end, bool const vtk);
void time_integration(real t_start, real t_end, real const dt, ParticleSystem P, bool const vtk);

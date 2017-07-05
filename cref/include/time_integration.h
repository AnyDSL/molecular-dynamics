#pragma once
#include <common.h>
#include <datastructures.h>
void initialize_system(const size_t np, real l[DIM]);

void deallocate_system();

void time_integration(real t_start, real t_end, real const dt, int const numthreads, bool const vtk);

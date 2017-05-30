#include <stdio.h>

#include <fileIO.h>
#include <time_integration.h>
#include <initialization.h>
#include <algorithm.h>

void run_simulation(const size_t np, real l[DIM], real const dt, real const t_end, bool const vtk) {
    ParticleSystem P;
    Constants c;
    init_constants(&c);
    init_random(np, l, c, &P);
    time_integration(0.0, t_end, dt, P, vtk);
    deallocate_particle_system(P);
}

void time_integration(real t_start, real t_end, real const dt, ParticleSystem P, bool const vtk) {
   real t = t_start;
   size_t count = 0;
   size_t i = 0;
   unsigned char str[32];

   compute_force(P);
   while(t < t_end) {
       t += dt; 
       if(vtk == true && count % 10 == 0) {
           generate_filename(i, "c", str, 32);
           fprint_particle_system(str, i, P);
           ++i;
       }
       update_coordinates(P, dt);
       compute_force(P);
       update_velocities(P, dt);
       ++count;
   }

}

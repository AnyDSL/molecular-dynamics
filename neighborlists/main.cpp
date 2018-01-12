#include <iostream>
#include <fstream>
#include "anydsl_includes.h"
#include "initialize.h"
#include "vtk.h"

int main()
{
    double dt = 1e-3;
    double const cutoff_radius = 5.0;
    double const epsilon = 1.0;
    double const sigma = 5.0;
    double potential_minimum = std::pow(2.0, 1.0/6.0) * sigma;
    std::cout << "Potential minimum at: " << potential_minimum << std::endl;

    AABB aabb1;
    double spacing1[3];
    for(int i = 0; i < 3; ++i) {
        aabb1.min[i] = 50;
        aabb1.max[i] = 50 + 50*potential_minimum;
        spacing1[i] = potential_minimum;
    }
    AABB aabb2;
    double spacing2[3];
    for(int i = 0; i < 3; ++i) {
        aabb2.min[i] = 50;
        aabb2.max[i] = 50 + 50*potential_minimum;
        spacing2[i] = potential_minimum;
    }
    double shift = potential_minimum + (aabb2.max[1] - aabb2.min[1]);
    aabb2.min[1] -= shift;
    aabb2.max[1] -= shift;

    int size = init_body_collision(aabb1, aabb2, spacing1, spacing2, 1, 1, 100, 5, 2048);
    std::cout << "Number of particles: " << size << std::endl;
    std::vector<double> masses(size);
    std::vector<Vector3D> positions(size);
    std::vector<Vector3D> velocities(size);
    //int nparticles = cpu_write_grid_data_to_arrays(masses.data(), positions.data(), velocities.data(), size);
    //write_vtk_to_file("/simdata/ja42rica//vtk/particles_0.vtk", masses, positions, velocities);
    for(int i = 0; i < 1000; ++i) {
        //std::cout << "Time step: " << i+1 << std::endl;
//        std::cout << "Integrate position" << std::endl;
        cpu_integrate_position(dt);
        //cpu_print_grid();
//        std::cout << "Redistribute particles" << std::endl;
        cpu_redistribute_particles();
//        std::cout << "Initialize clusters" << std::endl;
        cpu_initialize_clusters(256);
//        std::cout << "Assemble neighbor list" << std::endl;
        cpu_assemble_neighbor_lists(5.0);
//        std::cout << "Set forces to zero" << std::endl;
        cpu_set_forces_to_zero();
        //std::cout << "------------------------------------------" << std::endl;
//        std::cout << "Compute forces" << std::endl;
        cpu_compute_forces(cutoff_radius, epsilon, sigma);
//        std::cout << "Integrate velocity" << std::endl;
        cpu_integrate_velocity(dt);
        //cpu_print_grid();
//        std::cout << "vtk output" << std::endl;
        //nparticles = cpu_write_grid_data_to_arrays(masses.data(), positions.data(), velocities.data(), size);
        /*if(nparticles > 0) {
            masses.resize(nparticles);
            positions.resize(nparticles);
            velocities.resize(nparticles);
            std::string filename("/simdata/ja42rica/vtk/particles_");
            filename += std::to_string(i+1);
            filename += ".vtk";
            write_vtk_to_file(filename, masses, positions, velocities);
        }*/
    }
    cpu_deallocate_grid();
    return 0;
}
